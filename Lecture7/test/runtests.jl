using Test, ReferenceTests, BSON

include("../scripts/car_travels.jl")

## Unit tests
@testset "update_position" begin
    @test update_position(0.0, 10, 1, 1, 200)[1] ≈ 10.0
    @test update_position(0.0, 10, 1, 1, 200)[2] == 1

    @test update_position(0.0, 10, -1, 1, 200)[1] ≈ -10.0
    @test update_position(0.0, 10, -1, 1, 200)[2] == 1

    @test update_position(0.0, 10, -1, 1, 200)[1] ≈ -10.0
    @test update_position(0.0, 10, -1, 1, 200)[2] == 1
end


## Reference Tests with ReferenceTests.jl
# We put both arrays X and T into a BSON.jl and then compare them

"Compare all dict entries"
comp(d1, d2) = keys(d1) == keys(d2) &&
    all([ v1≈v2 for (v1,v2) in zip(values(d1), values(d2))])

# run the model
T, X = car_travel_1D()

# Test just at some random indices. As for larger models,
# storing the full output array would create really large files!
inds = [18, 27, 45, 68, 71, 71, 102, 110, 123, 144]

d = Dict(:X=> X[inds], :T=>T[inds])
@testset "Ref-tests" begin
    @test_reference "reftest-files/X.bson" d by=comp
end
