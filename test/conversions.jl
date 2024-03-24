@testset "commasep input" begin
  @test_throws MethodError MakiePlotting.commasep(3)
  @test_throws MethodError MakiePlotting.commasep(3, digits=1)
  @test_throws MethodError MakiePlotting.commasep(3, 2)
  @test "1,000" == MakiePlotting.commasep(1.0)
  @test "1,000" == MakiePlotting.commasep(1.f0)
  @test "1,000" == MakiePlotting.commasep(Float16(1))
end

@testset "commasep output" begin
  @test "3" == MakiePlotting.commasep(3.14, digits=0)
  @test "3,1" == MakiePlotting.commasep(3.14, digits=1)
  @test "3,14" == MakiePlotting.commasep(3.14, digits=2)
  @test "3,140" == MakiePlotting.commasep(3.14, digits=3)
  @test "3,140" == MakiePlotting.commasep(3.14)
  @test "1,002" == MakiePlotting.commasep(1.0015)
  @test "1,000" == MakiePlotting.commasep(0.9999)
  @test "0" == MakiePlotting.commasep(0.4999, digits=0)
  @test "1" == MakiePlotting.commasep(0.5, digits=0)
  @test "1" == MakiePlotting.commasep(1.4999, digits=0)
  @test "2" == MakiePlotting.commasep(1.5, digits=0)
  @test "2" == MakiePlotting.commasep(2.4999, digits=0)
  @test "3" == MakiePlotting.commasep(2.5, digits=0)
end
