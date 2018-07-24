 __precompile__()

module Diana

include("Client.jl")
#include("token.jl")
#include("lexer.jl")
#include("parser.jl")
#include("Schema.jl")

#import .Lexers: Tokenize,Tokensgraphql


export Queryclient, GraphQLClient#, Schema, Tokenize,Tokensgraphql, Parse



#include("_precompile.jl")
#_precompile_()
end # module
