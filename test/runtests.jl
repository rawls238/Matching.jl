using Matching
using Test

tests = ["basic"]

println("Running tests ...")

for t in tests
  fn = "test_$t.jl"
  println("* $fn ...")
  include(fn)
end

