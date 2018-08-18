using HTTP
using JSON

struct Client
	Query::Function
	serverUrl::Function
	headers::Function
	serverAuth::Function
end

struct Result
	Info
	Data::String
end

function Queryclient(data::String,check::Bool)
	if (check)
		return Validatequery(Parse(data))
	end
end

function Queryclient(url::String,data::String; vars::Dict=Dict(),auth::String="Bearer 0000", headers::Dict=Dict(),getlink::Bool=false,check::Bool=false,operationName::String="")

	if (getlink == true)
		#------------
		link =url*"?query="*HTTP.escapeuri(data)

		if length(operationName)>0
           link=link*"&operationName="*operationName
		end

		if length(vars)>0
			link=link*"&variables="*HTTP.escapeuri(JSON.json(vars))
		end
		return link
		#------------
	else

		myjson = Dict("query"=>data,"variables" => vars,"operationName" => operationName)
		my_headers = HTTP.mkheaders(["Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => auth])
		for (key, value) in headers
			HTTP.setheader(my_headers,key => value )
		end
		r = HTTP.post(url,my_headers,JSON.json(myjson))
		return Result(r,String(r.body))

	end
end


function Queryclient(queryurl::String)
	r=HTTP.get(queryurl)
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

	function Query(data::String; vars::Dict=Dict(),getlink::Bool=false,check::Bool=false,operationName::String="")
		if (check)
		    return Queryclient(data,check)
		end
		return Queryclient(my_url,data,vars=vars,auth=my_auth,headers=my_headersextras,getlink=getlink,operationName=operationName)

	end

	return Client(Query,serverUrl,setheaders,serverAuth)
end