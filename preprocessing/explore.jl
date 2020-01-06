using CSV
using Statistics
using DataFrames
using StatsBase

df = CSV.read("./input/validation.mif"; delim=";")

models = DataFrame(sort(collect(countmap(df[:, :Model])), by = tuple -> last(tuple), rev=true))
names!(models, [:model, :count])
scenario = DataFrame(sort(collect(countmap(df[:, :Scenario])), by = tuple -> last(tuple), rev=true))
names!(scenario, [:scenario, :count])
region = DataFrame(sort(collect(countmap(df[:, :Region])), by = tuple -> last(tuple), rev=true))
names!(region, [:region, :count])
variable = DataFrame(sort(collect(countmap(df[:, :Variable])), by = tuple -> last(tuple), rev=true))
names!(variable, [:variable, :count])

world = df[df.Region .== "World", :]
worldHistorical = world[world.Scenario .== "historical", :]

whl = worldHistorical[.!isnothing.(match.(r"^Resources\|Land Cover[^ ]", worldHistorical.Variable)), :]
whl1965 = select(whl, r".")
whl1965.year = 1965
whl1965.value = whl1965[:, Symbol(1965)]

whl2010 = select(whl, r".")
whl2010.year = 2010
whl2010.value = whl2010[:, Symbol(2010)]

whlCat = vcat(whl1965, whl2010)
whlCat = whlCat[:,[:Model, :Scenario, :Region, :Variable, :year, :value]]
names!(whlCat, [:model, :scenario, :region, :variable, :year, :value])

CSV.write("./output/land-use.csv", whlCat)
CSV.write("./output/land-use-world.csv", world)
