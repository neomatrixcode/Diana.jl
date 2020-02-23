module GraphqlController
	using Genie.Router, Genie.Requests
	using Diana
	using JSON

	const GQLString = Dict("tipo"=>"String")

	function ping_mutation(root, args, ctx, info)
		print(root, args, ctx, info)
		return string("Hello ", args["id"])
	end

	schema = Dict(
		"query"=> "Query",
		"Query"   => Dict(
			#=
			Currently not working because of current implementation requires some efforts
			"__schema" => Dict(
				"queryType" => Dict(
					"name" => GQLString
				),
				"mutationType" => Dict(
					"name" => GQLString
				),
				"subscriptionType" => Dict(
					"name" => GQLString
				)
			),
			=#
			"hello"=>Dict("tipo"=>"String"),
		),
		"mutation" => "Mutation",
		"Mutation" => Dict(
			"ping" => Dict(
				"args" => Dict(
					"id" => "String"
				),
				"tipo"=>"String"
			)
		)
	)

	resolvers=Dict(
		"Query"=>Dict(
			"hello" => (root,args,ctx,info)->(return "Hello World!"),
		),
		"Mutation" => Dict(
			"ping"=>ping_mutation
		)
	)

	my_schema = Schema(schema, resolvers)

	function playground()
		serve_static_file("/playground.html")
	end

	function graphql()
		body = jsonpayload()
		# print(body, body["query"])
		out = "{}"
		try
			out = my_schema.execute(body["query"], operationName=body["operationName"], Variables=body["variables"])
		catch err
			if isa(err, Diana.GraphQLError)
				out = err.msg
			else
				stack = stacktrace(catch_backtrace())
				stack = map((st)->([st.file, st.line]), stack)
				out = json(Dict(
					"name"=>typeof(err),
					"stacktrace"=>stack,
					"info"=> sprint(showerror, err),
					))
			end
		end
		return out
	end

	function register()
		route("/graphql", playground)
		route("/graphql", method="POST", graphql)
	end

	export register
end

