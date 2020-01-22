using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/land-use-results.csv")

# remove last (empty) column
df = df[.!ismissing.(df.Scenario),:]

select!(df, Not(:Model))
select!(df, Not(:Region))

df = stack(df, 4:size(df)[2])

rename!(df, [:year, :value, :scenario, :variable, :unit])

println(first(df, 8))

df[df.variable .== "Primary Energy|Biomass",:variable] .= "Biomass Energy"
df[df.variable .== "Carbon Sequestration|CCS|Biomass",:variable] .= "Carbon Sequestration from Biomass CCS"
df[df.variable .== "Price|Agriculture|Non-Energy Crops and Livestock|Index",:variable] .= "Food Price"

df = unstack(df, :year, :value)

CSV.write("../src/assets/data/landuseresults.csv", df)
