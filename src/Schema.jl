

mutable struct schema
  execute::Function
end

function Schema(_schema, resolvers)
my_schema = Parse(_schema)

    function execute(query::String)

      #=Validatequery(Parse(query))
      validatelosdos()
      operationName = GetOperation(document, operationName)
     function ExecuteRequest(schema, document, operationName, variableValues, initialValue)

      return ExecuteQuery(operation, schema, coercedVariableValues, initialValue)
      return ExecuteMutation(operation, schema, coercedVariableValues, initialValue).
      return Subscribe(operation, schema, coercedVariableValues, initialValue).
     end=#
    end

 return schema(execute)

end