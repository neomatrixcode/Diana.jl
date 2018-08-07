
struct GraphqlError <: Exception
           msg
       end

struct Rules
    rule
    function Rules()
        datos=Dict()
        datos["n_operation"]=0
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

		function rule(node::FragmentDefinition)
			if (node.typeCondition[2].name.value == "Subscription")
				if (length(node.selectionSet.selections)>1)
		    		return throw(GraphqlError("subscription must select only one top level field"))
		    	end
			end
		end

		function rule(node::OperationDefinition)
			valor = node.name
			#----------------------------------[
			datos["n_operation"]=datos["n_operation"]+1
            #-----------------------------------]
		    if (typeof(valor)<: Name)
			    valor= valor.value
				if(haskey(datos, "nombre_$(valor)"))
					return throw(GraphqlError("There can only be one operation named \'$(valor)\'."))
				else
					datos["nombre_$(valor)"]=true
				end
			else#--------------------------------[
                   datos["anonimo"]=true
				#---------------------------------]
		    end

		    if (node.operation == "subscription")
		    	if (length(node.selectionSet.selections)>1)
		    		return throw(GraphqlError("subscription must select only one top level field"))
		    	end
		    end

		    if ((datos["anonimo"]==true) && (datos["n_operation"]>1))
				return throw(GraphqlError("This anonymous operation must be the only defined operation."))
			end
		end
        new(rule)
    end
end
