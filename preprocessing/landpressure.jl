using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/validation.mif"; delim=";", missingstring="N/A")
vars = CSV.read("./input/var_selection.csv")

# remove last (empty) column
delete!(df, names(df)[end])

df = df[.!ismissing.(df[Symbol(1980)]),:]

# transform wide → long and remove rows without value
df = stack(df, 6:size(df)[2])
df.year = 0
df.year .= parse.(Int, string.(df.variable))
delete!(df, :variable)
rename!(df, [:value, :model, :scenario, :region, :variable, :unit, :year])
df = df[.!ismissing.(df.value),:]

# remove rows where region != world
df = df[df.region .== "World",:]
delete!(df, :region)

# remove rows with unwanted variables
df = df[map(v -> in(v, vars[:, 1]), df.variable), :]

# limit years between 1960 and 2019
df = df[.&(df.year .>= 1960, df.year .<= 2019), :]

df = unstack(df, :year, :value)

# replace missing values with empty strings
df[ismissing.(df.scenario), :scenario] .= ""
df[ismissing.(df.model), :model] .= ""

# filter to remove duplicates
df = df[df.model .!= "Bodirsky2015", :]
df = df[df.model .!= "FAO_crop_past", :]
df = df[df.model .!= "FAOmassbalance", :]
df = df[df.scenario .!= "projection", :]
# df = df[df.model .!= "MAgPIEown", :]

df = df[.!.&(df.model .== "MAgPIEown", df.variable .!= "Resources|Land Cover|Forest|+|Managed Forest", df.variable .!= "Resources|Land Cover|Forest|+|Natural Forest"), :]
df = df[.!.&(df.model .== "Bodirsky", df.variable .== "Resources|Nitrogen|Cropland Budget|Inputs|+|Fertilizer"), :]
df = df[.!.&(df.variable .== "Income", df.unit .!= "US\$05 PPP/cap/yr"), :]
df = df[.|(df.model .!= "EDGAR_LU", df.variable .== "Emissions|CO2|Land|+|Land Use Change"), :]

sort!(df, [order(:variable), order(:model), order(:scenario)])
CSV.write("./output/landpressure.csv", df)

# check for duplicates

nonunique(df, :variable)
dupVars = unique(df[nonunique(df, :variable), :variable])
dfDupVars = df[map(v -> in(v, dupVars[:, 1]), df.variable), :]
sort!(dfDupVars, [order(:variable), order(:model), order(:scenario)])

CSV.write("./output/landpressure-duplicates.csv", dfDupVars)
