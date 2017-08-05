

type schema
  execute::Function
end



function Schema(algo)
	
	function execute(query::String)
		ast= Parse(query)
        ast
	end

return schema(execute) 

end