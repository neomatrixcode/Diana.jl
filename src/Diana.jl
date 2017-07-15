module Diana

using Requests
import Requests: post

export query

function query(url::String,data::String)

  r=post(url; json = Dict("query"=>data),headers = Dict("Accept" => "application/json"))
  
  r_data = r.data 
  length_data=length(r_data)

  content=""
  if(length_data>=1)
    for i=1:length_data
      content*="$(Char(r_data[i]))"
    end
  end

  content
end


end # module
