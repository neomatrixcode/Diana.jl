struct getfield_types <:Rule
  enter::Function
  leave::Function
    simbolos::Dict
  function getfield_types()
    simbolos= Dict()
    nombre=""
    function enter(node)
      if (node.kind == "ObjectTypeDefinition")
         nombre = node.name.value
                 push!(simbolos, nombre => Dict())
      end
      if (node.kind == "FieldDefinition")
        nombrecampo= node.name.value
        push!(simbolos[nombre], nombrecampo => Dict() )
        push!(simbolos[nombre][nombrecampo], "tipo" =>node.tipe.name.value )
        push!(simbolos[nombre][nombrecampo], "value" =>"" )

        if length(node.arguments)>0
          push!(simbolos[nombre][nombrecampo], "args" => Dict() )

                 for data in node.arguments
                     push!(simbolos[nombre][nombrecampo]["args"], data.name.value => data.tipe.name.value )
                 end
        end
      end
      if (node.kind == "OperationTypeDefinition")
        push!(simbolos, node.operation => node.tipe.name.value )
      end
    end
    function leave(node)
    end
    new(enter,leave,simbolos)
  end
end



struct extract_operation <:Rule
  enter::Function
  leave::Function
  found:: Dict
  function extract_operation(operationName::String)
    active= true
    found = Dict()
    function enter(node::Node)
      if (active==true) && (node.kind == "OperationDefinition")
        if node.name !== nothing
           if (node.name.value == operationName)
              push!(found, "operation_type" => node.operation, "extracted_operation" => node)
              active=false
           end
        end
      end
    end
    function leave(node::Node)
    end
    new(enter,leave,found)
  end
end