using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./preprocessing/input/land-emissions.csv")

# remove last (empty) column
select!(df, Not(:Model))
select!(df, Not(:Region))

df = df[.!ismissing.(df.Scenario),:]

df = stack(df, 4:size(df)[2])

rename!(df, [:year, :value, :scenario, :variable, :unit])
df[df.unit .== "kt N2O/yr",:value] /= 1000

df.source = map(v -> isnothing(match(r"AFOLU", v)) ? "total" : "afolu", df.variable)
# df.gas = ""
df[df.unit .== "kt N2O/yr",:variable] .= "N₂0"
df[df.unit .== "Mt CO2/yr",:variable] .= "CO₂"
df[df.unit .== "Mt CH4/yr",:variable] .= "CH₄"

df[df.unit .== "kt N2O/yr",:unit] .= "Mt/year"
df[df.unit .== "Mt CO2/yr",:unit] .= "Mt/year"
df[df.unit .== "Mt CH4/yr",:unit] .= "Mt/year"

df = unstack(df, :year, :value)

CSV.write("./src/assets/data/land-emissions.csv", df)
