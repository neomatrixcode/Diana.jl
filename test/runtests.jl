using Diana
using Test

@testset "Diana" begin
include("cliente.jl");
include("validationast.jl");
include("parser.jl");
include("lexer.jl");
include("execute.jl");

end;

