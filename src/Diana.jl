 __precompile__()

module Diana

include("Client.jl")
include("token.jl")
include("lexer.jl")
include("Schema.jl")

import .Lexers: tokenize

export Query, GraphQLClient, Schema, tokenize


include("_precompile.jl")
_precompile_()
end # module
