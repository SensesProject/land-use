using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/ssp-comparison.csv"; missingstring="N/A")

df = df[.!ismissing.(df.Scenario),:]

select!(df, Not(:Region))

df = stack(df, 5:size(df)[2])

println(first(df, 2))

rename!(df, [:year, :value, :model, :scenario, :variable, :unit])

first(df[df.variable .== "GDP|PPP", :], 2)

# df[df.variable .== "GDP|PPP", :value] ./= df[df.variable .== "Population", :value]
df = df[df.variable .!= "GDP|PPP", :]
df = df[df.unit .!= "million ha", :]

df = unstack(df, :year, :value)

sort!(df, [order(:variable, rev=true), order(:scenario)])

CSV.write("../src/assets/data/sspcomparison.csv", df)
