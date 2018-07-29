 __precompile__()

module Diana

include("Client.jl")
include("token.jl")
include("lexer.jl")
include("parser.jl")
#include("Schema.jl")

import .Lexers: Tokenize,Tokensgraphql


export Queryclient, GraphQLClient,Tokensgraphql,Tokenize,Parse #Schema



#include("_precompile.jl")
#_precompile_()
end # module
