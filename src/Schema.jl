include("rules/schema.jl")
using JSON
mutable struct schema
  execute::Function
  symbol_table::Dict
end

function Schema(_schema::String, resolvers)
symbol_extract =getfield_types()
vi= Visitante(Parse(_schema))
vi.visitante(symbol_extract)
symbol_table = Dict("symbols"=>symbol_extract.simbolos,"types"=>symbol_extract.tipos)

    function execute(query::String, operationName=nothing, coercedVariableValues=nothing, initialValue=nothing)
      #si la solicitud no esta validada, validarla
      document = Parse(query)
      Validatequery(document)
      #pero si esta misma solicitud ya se valido antes, pues solo recuperarla de cache

       operation= ""

       if operationName==nothing
          operation= document
      #else
          #operation = GetOperation(document,operationName)
      end
      type_operation = "query"

      if type_operation =="query"
        return JSON.json(ExecuteQuery(operation, symbol_table["types"],resolvers, coercedVariableValues, initialValue))
      elseif type_operation == "mutation"
        return JSON.json(ExecuteMutation(operation, symbol_table, coercedVariableValues, initialValue))
      elseif type_operation == "subscribe"
        return JSON.json(Subscribe(operation, symbol_table, coercedVariableValues, initialValue))
      end

      return JSON.json("{}")#
    end

 return schema(execute,symbol_table)

end