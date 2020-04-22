using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/land-use-change-ssp.csv")

# remove last (empty) column
df = df[.!ismissing.(df.Scenario),:]

select!(df, Not(:Model))
select!(df, Not(:Region))

df = stack(df, 4:size(df)[2])

rename!(df, [:year, :value, :scenario, :variable, :unit])

println(first(df, 8))

# df.source = map(v -> isnothing(match(r"AFOLU", v)) ? "total" : "afolu", df.variable)
# df.gas = ""
df[df.variable .== "Land Cover|Cropland",:value] -= df[df.variable .== "Land Cover|Cropland|Energy Crops",:value]

df[df.variable .== "Land Cover|Cropland",:variable] .= "Non-Bioenergy Crops"
df[df.variable .== "Land Cover|Cropland|Energy Crops",:variable] .= "Bioenergy Crops"
df[df.variable .== "Land Cover|Pasture",:variable] .= "Pasture"
df[df.variable .== "Land Cover|Forest",:variable] .= "Forest"

df = unstack(df, :year, :value)

CSV.write("../src/assets/data/landusechangessp.csv", df)
