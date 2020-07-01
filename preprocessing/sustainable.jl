using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/sustainable.csv";)
vars = CSV.read("./input/sustainable_vars.csv")

# remove last row 🙄
df = df[.!ismissing.(df.Scenario),:]
# remove region col
select!(df, Not(:Region))
df = stack(df, 5:size(df)[2])
rename!(df, [:year, :value, :model, :scenario, :variable, :unit])
# df[occursin.("N2O", df.variable), :value] /= 1000
df[occursin.("N2O", df.variable), :unit] = "Mt N₂O/yr"
df[occursin.("CO2", df.variable), :unit] = "Gt CO₂/yr"
df[occursin.("CH4", df.variable), :unit] = "Mt CH₄/yr"
df = unstack(df, :year, :value)

df[occursin.("Def", df.scenario), :scenario] = "default"
df[occursin.("Sust", df.scenario), :scenario] = "sustainable"

# sort!(df, [order(:variable, rev=true), order(:scenario)])
df = join(vars,df,on = :variable, kind= :outer)
CSV.write("../src/assets/data/sustainable.csv", df)
