
struct GraphqlError <: Exception
           msg
       end

struct Rules
    rule
    function Rules()
        datos=Dict()
        datos["nquery"]=0
        datos["anonimo"]=false
		function rule(node::TypeExtensionDefinition)
			return throw(GraphqlError("GraphQL cannot execute a request containing a TypeExtensionDefinition."))
		end

		function rule(node::ObjectTypeDefinition)
			return throw(GraphqlError("GraphQL cannot execute a request containing a ObjectTypeDefinition."))
		end

		function rule(node::SchemaDefinition)
			return throw(GraphqlError("GraphQL cannot execute a request containing a SchemaDefinition."))
		end

		function rule(node::OperationDefinition)
			valor = node.name

		    if valor!=nothing
			    valor= valor.value
			    #----------------------------------[
			    if (node.operation=="query")
                   datos["nquery"]=datos["nquery"]+1
			    end
                #-----------------------------------]
				if(haskey(datos, "nombre_$(valor)"))
					return throw(GraphqlError("There can only be one operation named \'$(valor)\'."))
				else
					datos["nombre_$(valor)"]=true
				end
			else#--------------------------------[
				if (node.operation=="query")
                   datos["nquery"]=datos["nquery"]+1
                   datos["anonimo"]=true
			    end
				#---------------------------------]
		    end

		    if ((datos["anonimo"]==true) && (datos["nquery"]>1))
				return throw(GraphqlError("This anonymous operation must be the only defined operation."))
			end
		end
        new(rule)
    end
end
