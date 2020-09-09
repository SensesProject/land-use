using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./preprocessing/input/land-pressure.csv")
vars = CSV.read("./preprocessing/input/land-pressure-attributes.csv")

# remove last (empty) column
select!(df, Not(names(df)[end]))

# transform wide → long and remove rows without value
df = stack(df, 6:size(df)[2])
df.year = parse.(Int, string.(df.variable))
select!(df, Not(:variable))
rename!(df, [:model, :scenario, :region, :variable, :unit, :value, :year])
df = df[.!ismissing.(df.value),:]

# limit years between 1960 and 2019
df = df[.&(df.year .>= 1960, df.year .<= 2019), :]

df = unstack(df, :year, :value)

# replace missing values with empty strings
df[ismissing.(df.scenario), :scenario] .= ""
df[ismissing.(df.model), :model] .= ""

# calc afolu emissions
emissionsAgr = stack(df[occursin.(r"\+\|Agriculture", df.variable), :], 6:size(df)[2]; variable_name = :year)
emissionsLand = stack(df[occursin.(r"\+\|Land-use Change", df.variable), :], 6:size(df)[2]; variable_name = :year)

emissionsAgr.value += emissionsLand.value
agr = unstack(emissionsAgr, :year, :value)
df = df[.!occursin.(r"Emissions", df.variable), :]
df = vcat(agr, df)

# fix fish prices
foreach(v -> df[df.variable .== "Prices|Agriculture|Fish", Symbol(v)] .= missing, 1960:1979)
df
# sort based on var-selection
df = join(vars,df,on = :variable, kind= :outer)
df = df[.!occursin.(r"Land-use Change", df.variable), :]
CSV.write("./src/assets/data/land-pressure.csv", df)