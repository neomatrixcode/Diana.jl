module Diana

using Requests
import Requests: post

export query

function query(url::String,data::String)
  r=post(url; json = Dict("query"=>data),headers = Dict("Accept" => "application/json"))  
  content=""
  map(x -> (content*="$(Char(x))"), r.data)
  content
end


end # module
