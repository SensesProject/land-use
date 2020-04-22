using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/validation.mif"; delim=";", missingstring="N/A")
vars = CSV.read("./input/var_selection.csv")

# remove last (empty) column
select!(df, Not(names(df)[end]))

df = df[.!ismissing.(df[!, Symbol(1980)]),:]

# transform wide → long and remove rows without value
df = stack(df, 6:size(df)[2])
df.year = parse.(Int, string.(df.variable))
select!(df, Not(:variable))
rename!(df, [:value, :model, :scenario, :region, :variable, :unit, :year])
df = df[.!ismissing.(df.value),:]

# remove rows where region != world
df = df[df.region .== "World",:]
select!(df, Not(:region))
# remove rows with unwanted variable
df = df[map(v -> in(v, vars[:, 1]), df.variable), :]

# limit years between 1960 and 2019
df = df[.&(df.year .>= 1960, df.year .<= 2019), :]

df = unstack(df, :year, :value)

# replace missing values with empty strings
df[ismissing.(df.scenario), :scenario] .= ""
df[ismissing.(df.model), :model] .= ""

# filter to remove duplicates
df = df[.!.&(df.variable .== "Income", df.unit .!= "US\$05 PPP/cap/yr"), :]
df = df[.!.&(occursin.(r"Calorie Supply", df.variable), df.model .!= "FAO"), :]
df = df[.!.&(occursin.(r"Land Cover.*\+", df.variable), df.model .!= "MAgPIEown"), :]
df = df[.!.&(occursin.(r"Nitrogen", df.variable), df.model .!= "Lassaletta2014"), :]
df = df[.!.&(occursin.(r"Emissions", df.variable), df.model .!= "PRIMAPhist"), :]

# calc afolu emissions
emissionsAgr = stack(df[occursin.(r"\+\|Agriculture", df.variable), :], 5:size(df)[2]; variable_name = :year)
emissionsLand = stack(df[occursin.(r"\+\|Land-use Change", df.variable), :], 5:size(df)[2]; variable_name = :year)

emissionsAgr.value += emissionsLand.value
agr = unstack(emissionsAgr, :year, :value)
df = df[.!occursin.(r"Emissions", df.variable), :]
df = vcat(agr, df)

# fix fish prices
foreach(v -> df[df.variable .== "Prices|Agriculture|Fish", Symbol(v)] .= missing, 1960:1979)

# sort based on var-selection
df = join(vars,df,on = :variable, kind= :outer)
df = df[.!occursin.(r"Land-use Change", df.variable), :]
CSV.write("../src/assets/data/landpressure.csv", df)
CSV.write("./output/landpressure.csv", df)

# check for duplicates

nonunique(df, :variable)
dupVars = unique(df[nonunique(df, :variable), :variable])
dfDupVars = df[map(v -> in(v, dupVars[:, 1]), df.variable), :]
# sort!(dfDupVars, [order(:variable), order(:model), order(:scenario)])

CSV.write("./output/landpressure-duplicates.csv", dfDupVars)
