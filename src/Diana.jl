module Diana

include("client.jl")
include("token.jl")
include("lexer.jl")
include("Parser.jl")
include("Schema.jl")
include("Validate.jl")


import .Lexers: Tokenize,Tokensgraphql


export Queryclient, GraphQLClient,Tokensgraphql,Tokenize,Parse,Schema,visitInParallel



include("_precompile.jl")
_precompile_()
end # module
