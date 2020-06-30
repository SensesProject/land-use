using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/mitigation-land-change.csv")

# remove last (empty) column
select!(df, Not(:Model))
select!(df, Not(:Region))

df = df[.!ismissing.(df.Scenario),:]

df = stack(df, 4:size(df)[2])

rename!(df, [:year, :value, :scenario, :variable, :unit])

df[df.variable .== "Land Cover|Cropland",:value] -= df[df.variable .== "Land Cover|Cropland|Energy Crops",:value]

df[df.variable .== "Land Cover|Cropland",:variable] .= "Non-Bioenergy Crops"
df[df.variable .== "Land Cover|Cropland|Energy Crops",:variable] .= "Bioenergy Crops"
df[df.variable .== "Land Cover|Pasture",:variable] .= "Pasture"
df[df.variable .== "Land Cover|Forest",:variable] .= "Forest"
df[df.variable .== "Land Cover|Other Natural Land",:variable] .= "Other Natural Land"

df = unstack(df, :year, :value)

CSV.write("../src/assets/data/mitigation-land-change.csv", df)
