using FastGroupBy, DataBench
using Base.Test
import DataFrames.DataFrame

#using DataFrames, CSV
#import Base.ht_keyindex
# write your own tests here

@time b = run_juliadb_bench(1_000_000, 100)
@time a = R_bench(1_000_000, 100; libpath = "C:/Users/dzj/Documents/R/win-library/3.4")
c = Dict(n => b[n]/a[n][1] for n in names(a))
@test length(c) == 11

@time b = run_juliadb_bench()
@time a = R_bench(;libpath = "C:/Users/dzj/Documents/R/win-library/3.4")

# compute relativities to R's data.table
c = Dict(n => b[n]/a[n][1] for n in names(a))
@test length(c) == 11

# collate the results
abc = vcat(a, DataFrame(;b...), DataFrame(;c...))
abc[:role] = ["R","Julia","Ratio"];

file1 = replace("test/results/results $(now()).csv",":","")
using CSV
CSV.write(file1, abc);

# files = open("test/results/"*readdir("test/results/")[2], "r")
# abc1 = deserialize( files)
