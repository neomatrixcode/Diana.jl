include("rules/schema.jl")
using JSON
mutable struct schema
  execute::Function
end

function GetOperation(document::Node,operationName::String)

  operation=extract_operation(operationName)
  vi= Visitante(document)
  vi.visitante(operation)
  return operation
end

function Schema(_schema::String, resolvers, context=nothing)
if '.' in _schema
  _schema = open(_schema) do file
      read(file, String)
    end
end

symbol_extract =getfield_types()
vi= Visitante(Parse(_schema))
vi.visitante(symbol_extract)
symbol_table = symbol_extract.simbolos

return Schema(symbol_table, resolvers, context)

end



function Schema(_schema::Dict, resolvers, context=nothing)

symbol_table = _schema

    function execute(query::String, operationName=nothing, coercedVariableValues=nothing, initialValue=nothing)
      #si la solicitud no esta validada, validarla
      document = Parse(query)

      count_operations = length(document.definitions)

      if (count_operations > 1) && (operationName==nothing)
        throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"No operation named.\"}]}"))
      end

      Validatequery(document)

       operation= nothing
       type_operation = " "

       if operationName==nothing
          operation= document
          type_operation= document.definitions[1].operation
      else
          data = GetOperation(document,operationName)
          if data.extracted_operation == nothing
              throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"$(operationName) operation not found.\"}]}"))
          else
            operation = data.extracted_operation
            type_operation = data.operation_type
          end
      end

       #pero si esta misma solicitud ya se valido antes, pues solo recuperarla de cache


      if type_operation =="query"
        return JSON.json(ExecuteQuery(operation, symbol_table,resolvers,context, coercedVariableValues, initialValue))
      elseif type_operation == "mutation"
        return JSON.json(ExecuteMutation(operation, symbol_table, coercedVariableValues, initialValue))
      elseif type_operation == "subscribe"
        return JSON.json(Subscribe(operation, symbol_table, coercedVariableValues, initialValue))
      end

      return JSON.json("{}")#
    end

 return schema(execute)

end