using DataFrames, CSV, Statistics, StatsBase

df = CSV.read("./input/ssp-comparison.csv"; missingstring="N/A")

df = df[.!ismissing.(df.Scenario),:]

CSV.write("../src/assets/data/sspcomparison.csv", df)
