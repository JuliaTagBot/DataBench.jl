using FastGroupBy, DataBench
using Base.Test
import DataFrames.DataFrame
using SplitApplyCombine
@time addprocs(4)
@time @everywhere using FastGroupBy
#using DataFrames, CSV
#import Base.ht_keyindex
# write your own tests here

@time b = run_juliadb_bench(1_000_000, 100)
@time b1 = run_juliadb_bench_pmap(1_000_000, 100)
# @time a = R_bench(1_000_000, 100; libpath = "C:/Users/dzj/Documents/R/win-library/3.4")
# c = Dict(n => b[n]/a[n][1] for n in names(a))
#
# @test length(c) == 11

@time b1 = run_juliadb_bench_pmap()
gc()
file1 = replace("test/results/julia_pmap $(now()).csv",":","")
using CSV
CSV.write(file1, DataFrame(;b1...));

@time b = run_juliadb_bench()
gc()
file1 = replace("test/results/julia $(now()).csv",":","")
using CSV
CSV.write(file1, DataFrame(;b...));

rd = readdir("test/results/")
substr(rd,1,1)

@time a = R_bench(;libpath = "C:/Users/dzj/Documents/R/win-library/3.4")
file1 = replace("test/results/r $(now()).csv",":","")
using CSV
CSV.write(file1, a);

# compute relativities to R's data.table
c = Dict(n => b[n]/a[n][1] for n in names(a))
@test length(c) == 11

# collate the results
abc = vcat(a, DataFrame(;b...), DataFrame(;c...))
abc[:role] = ["R","Julia","Ratio"];


# files = open("test/results/"*readdir("test/results/")[2], "r")
# abc1 = deserialize( files)
#
# using DataBench
# dt = createIndexedTable(Int64(2e9/8), 100)
# @time sumby(dt, :id6, :v1)
# gc()
# @time sumby(dt, :id6, :v1)
# gc()
# @time groupreduce(x->x[1], x->(x[2],1), (x,y) ->(x[1]+y[1],x[2]+y[2]), zip(column(dt,:id6), column(dt,:v1)))
# gc()
# @time groupreduce(x->x[1], x->(x[2],1), (x,y) ->(x[1]+y[1],x[2]+y[2]), zip(column(dt,:id6), column(dt,:v1)))
# gc()
