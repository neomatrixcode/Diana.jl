module Diana

using Requests
import Requests: post

export query

function query(url::String,data::String,auth::String="Bearer 0000",vars::Dict=Dict())
  r=post(url; json = Dict("query"=>data,"variables" => vars),headers = Dict("Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => auth))  
  content=""
  r.status == 200 ? map(x -> (content*="$(Char(x))"), r.data): println(r)
  content
end


end # module
