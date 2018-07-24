using HTTP
using JSON

mutable struct Client
  Queryclient::Function
  serverUrl::Function
  serverAuth::Function
end

mutable struct Result
	Info
	Data::String
end

function postexecute(url, body, headers, headersextra )
 for (key, value) in headersextra
    HTTP.setheader(headers,key => value )
  end

return HTTP.post(url,headers,JSON.json(body))
end

function Queryclient(url::String,data::String; vars::Dict=Dict(),auth::String="Bearer 0000", headers::Dict=Dict())

	myjson = Dict("query"=>data,"variables" => vars,"operationName" => Dict())

  r=postexecute(url, myjson,HTTP.mkheaders(["Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => auth]), headers)

  return Result(r,String(r.body))
end

function GraphQLClient(url::String, auth::String="Bearer 0000", headers::Dict=Dict())

my_url::String= url
my_auth::String= auth

	function serverUrl(url::String)
		my_url = url
	end

	function serverAuth(auth::String)
		my_auth= auth
	end

	function Queryclient(data::String;vars::Dict=Dict())
		myjson = Dict("query"=>data,"variables" => vars,"operationName" => Dict())
	  r=postexecute(my_url, myjson,HTTP.mkheaders(["Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => my_auth]), headers)

	  return Result(r,String(r.body))
	end

	return Client(Queryclient,serverUrl,serverAuth)
end