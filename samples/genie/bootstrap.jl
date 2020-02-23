cd(@__DIR__)
using Pkg
Pkg.activate(".")

# To load diana changes automatically, uncomment if you wish to try new things with Diana
# Pkg.add(PackageSpec(name="Diana", url="../../"))

function main()
    include(joinpath("src", "TbsServerJulia.jl"))
end; main()
