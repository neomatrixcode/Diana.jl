module Diana

using Requests
import Requests: post

export Query, GraphQLClient

include("client.jl")

end # module
