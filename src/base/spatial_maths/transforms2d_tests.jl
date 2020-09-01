### The Testing file for the 2d transformations
using Test

include("transforms2d.jl")

# Testing rot2
@test size(rot2(20, "deg")) == (2,2)
@test_throws ErrorException rot2(20, "dg")
@test (rot2(30)) == Array
