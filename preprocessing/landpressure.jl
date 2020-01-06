using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/validation.mif"; delim=";", missingstring="N/A")
vars = CSV.read("./input/var_selection.csv"; delim=";")

df[df.Variable .== "Consumption", :]

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

CSV.write("./output/landpressure.csv", df)

# variables = DataFrame(sort(collect(countmap(df[:, :variable])), by = tuple -> last(tuple), rev=true))
# names!(variables, [:variable, :count])

# df[in(df.variable .== vars[:, 1]),:]

nonunique(df, :variable)
dupVars = unique(df[nonunique(df, :variable), :variable])
dfDupVars = df[map(v -> in(v, dupVars[:, 1]), df.variable), :]
sort!(dfDupVars, [order(:variable), order(:model), order(:scenario)])

CSV.write("./output/landpressure-duplicates.csv", dfDupVars)

CSV.write("./output/landpressure-uniques.csv", unique(df, :variable))

head(df)

df[6, 170:200]
