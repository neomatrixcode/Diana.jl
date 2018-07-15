module Diana

using Requests
import Requests: post

export Queryclient, GraphQLClient

include("client.jl")

end # module
