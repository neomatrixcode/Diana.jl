module Diana

include("client.jl")
include("token.jl")
include("lexer.jl")
include("Parser.jl")
include("Schema.jl")
include("Visitor.jl")


import .Lexers: Tokenize,Tokensgraphql


export Queryclient, GraphQLClient,Tokensgraphql,Tokenize,Parse,Schema,visitante



include("_precompile.jl")
_precompile_()
end # module
