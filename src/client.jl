using HTTP
using JSON

mutable struct Client
	Query::Function
	serverUrl::Function
	headers::Function
	serverAuth::Function
end

mutable struct Result
	Info
	Data::String
end


function Queryclient(url::String,data::String; vars::Dict=Dict(),auth::String="Bearer 0000", headers::Dict=Dict())

	myjson = Dict("query"=>data,"variables" => vars,"operationName" => Dict())

	my_headers = HTTP.mkheaders(["Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => auth])

	for (key, value) in headers
		HTTP.setheader(my_headers,key => value )
	end

	r = HTTP.post(url,my_headers,JSON.json(myjson))

	return Result(r,String(r.body))
end

function GraphQLClient(url::String; auth::String="Bearer 0000", headers::Dict=Dict())

	my_url::String= url
	my_auth::String= auth
	my_headersextras::Dict= headers

	function serverUrl(url::String)
		my_url = url
	end

	function setheaders(headers::Dict)
	    my_headersextras=headers
	end

	function serverAuth(auth::String)
		my_auth= auth
	end

	function Query(data::String; vars::Dict=Dict())

		return Queryclient(my_url,data,vars=vars,auth=my_auth,headers=my_headersextras)

	end

	return Client(Query,serverUrl,setheaders,serverAuth)
end