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
"""
    Schema(_schema::String, resolvers::Dict; context=nothing)

Receive a schema in string format or in a text file, return an object of type schema
"""
function Schema(_schema::String, resolvers::Dict; context=nothing)
if '.' in _schema
  _schema = open(_schema) do file
      read(file, String)
    end
end

symbol_extract =getfield_types()
vi= Visitante(Parse(_schema))
vi.visitante(symbol_extract)
symbol_table = symbol_extract.simbolos

return Schema(symbol_table, resolvers, context=context)

end


"""
    Schema(_schema::Dict, resolvers::Dict; context=nothing)
Receive a schema in dictionary format, return an object of type schema
"""
function Schema(_schema::Dict, resolvers::Dict; context=nothing)

symbol_table = _schema

    function execute(query::String; operationName=nothing, Variables=nothing, initialValue=nothing)
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
          if !haskey(data.found, "extracted_operation")
              throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"$(operationName) operation not found.\"}]}"))
          else
            operation = data.found["extracted_operation"]
            type_operation = data.found["operation_type"]
          end
      end

       #pero si esta misma solicitud ya se valido antes, pues solo recuperarla de cache


      if type_operation =="query"
        return JSON.json(ExecuteQuery(operation, symbol_table,resolvers, context , Variables=Variables, initialValue=nothing))
      elseif type_operation == "mutation"
        return JSON.json(ExecuteMutation(operation, symbol_table,resolvers, context , Variables=Variables, initialValue=nothing))
      #elseif type_operation == "subscribe"
       # return JSON.json(Subscribe(operation, symbol_table,resolvers, context , Variables=nothing, initialValue=nothing))
      end

      return JSON.json("{}")#
    end

 return schema(execute)

end