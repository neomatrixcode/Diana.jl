include("parser.jl")

type schema
  execute::Function
end



function Schema(algo)
	
	function execute(query::String)
		parser(query)
	end

return schema(execute) 

end