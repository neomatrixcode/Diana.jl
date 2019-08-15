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
                 push!(simbolos[nombre], node.name.value => Dict("tipo" =>node.tipe.name.value) )
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
  extracted_operation::Union{Nothing,Node}
  operation_type::String
  function extract_operation(operationName::String)
    extracted_operation= nothing
    operation_type=""
    function enter(node::Node)
      if (node.kind == "OperationDefinition")

        if node.name != nothing
           if node.name.value == operationName
               operation_type = node.operation
               extracted_operation = node
               quit()
           end
        end

      end
    end
    function leave(node::Node)
    end
    new(enter,leave,operation_type,extracted_operation)
  end
end