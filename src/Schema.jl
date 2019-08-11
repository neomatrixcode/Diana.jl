using JSON

mutable struct schema
  execute::Function
  tbn
end

function Schema(_schema::String, resolvers)
simbolos =getfield_types()
vi= Visitante(Parse(_schema))
vi.visitante(simbolos)

    function execute(query::String)
      myquery = Parse(query)
      Validatequery(myquery)
      return JSON.json(ExecuteQuery(myquery, resolvers, simbolos))
      #=Validatequery(Parse(query))
      validatelosdos()
      operationName = GetOperation(document, operationName)
     function ExecuteRequest(schema, document, operationName, variableValues, initialValue)

      return ExecuteQuery(operation, schema, coercedVariableValues, initialValue)
      return ExecuteMutation(operation, schema, coercedVariableValues, initialValue).
      return Subscribe(operation, schema, coercedVariableValues, initialValue).
     end=#
    end

 return schema(execute,simbolos)

end