type Client
  Query::Function
  serverUrl::Function
  serverAuth::Function
end

type Result
	Info
	Data::String
end

function Query(url::String,data::String; vars::Dict=Dict(),auth::String="Bearer 0000")
  r=post(url; json = Dict("query"=>data,"variables" => vars),headers = Dict("Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => auth))  
  content=""
  r.status == 200 ? map(x -> (content*="$(Char(x))"), r.data): content="{\"data\":{}}"
  return Result(r,content)
end

function GraphQLClient(url::String,auth::String="Bearer 0000")

my_url::String= url
my_auth::String= auth

	function serverUrl(url::String)
		my_url = url
	end

	function serverAuth(auth::String)
		my_auth= auth
	end

	function Query(data::String;vars::Dict=Dict())
	  r=post(my_url; json = Dict("query"=>data,"variables" => vars),headers = Dict("Accept" => "application/json","Content-Type" => "application/json" ,"Authorization" => my_auth))  
	  content=""
	  r.status == 200 ? map(x -> (content*="$(Char(x))"), r.data): content="{\"data\":{}}"
	  return Result(r,content)
	end

	return Client(Query,serverUrl,serverAuth)
end