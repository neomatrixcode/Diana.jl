
struct GraphqlError <: Exception
           msg
       end

struct Rules
    rule
    leave
    function Rules()
        datos=Dict()
        datos["n_operation"]=0
        datos["anonimo"]=false
        datos["name_fragments"]=Dict()
        datos["name_operations"]=Dict()
        datos["used_fragments"]=Dict()
        datos["cycles_fragments"]=Dict()
		datos["ultimateFragmentSpread"]=""
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
			datos["ultimateFragmentSpread"]=nothing
			if (node.typeCondition[2].name.value == "Subscription")
				if (length(node.selectionSet.selections)>1)
					return throw(GraphqlError("subscription must select only one top level field"))
				end
			end


			valor= node.name.value
			if(haskey(datos["name_fragments"], "$(valor)"))
				return throw(GraphqlError("There can only be one fragment named \'$(valor)\'."))
			else
				datos["name_fragments"]["$(valor)"]=false
			end
		end

		function rule(node::FragmentSpread)
			nombre = node.name.value
			datos["used_fragments"]["$(nombre)"]=true
			datos["ultimateFragmentSpread"] = nombre
		end

		function leave(x::FragmentDefinition)
			if (typeof(datos["ultimateFragmentSpread"])<:String)
				datos["cycles_fragments"][x.name.value]=datos["ultimateFragmentSpread"]
			end
		end

		function leave(x::Document)
			#=for nombre in keys(datos["name_fragments"])
				if !(haskey(datos["used_fragments"], nombre))
				    return throw(GraphqlError("Fragment $(nombre) is not used."))
				end
			end

			for nombre in keys(datos["used_fragments"])
				if !(haskey(datos["name_fragments"], nombre))
				    return throw(GraphqlError("Unknown fragment $(nombre)."))
				end
			end=#

			for (key, value) in datos["cycles_fragments"]
                inicio = key
                traza=""
    			while(haskey(datos["cycles_fragments"], value))
    				traza=traza*",$(value)"
    				value = datos["cycles_fragments"][value]
                    if (value == inicio)
    					return throw(GraphqlError("Cannot spread fragment $(inicio) within itself via $(traza)."))
                    end
    			end
    			break
 			end

		   for (key, value) in merge(datos["name_fragments"], datos["used_fragments"])
    			if(value==false)
    				return throw(GraphqlError("Fragment $(key) is not used."))
    			end
 			end

		    for (key, value) in merge(datos["used_fragments"],datos["name_fragments"])
    			if(value==true)
    				return throw(GraphqlError("Unknown fragment $(key)."))
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
				if(haskey(datos["name_operations"], "$(valor)"))
					return throw(GraphqlError("There can only be one operation named \'$(valor)\'."))
				else
					datos["name_operations"]["$(valor)"]=true
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
        new(rule,leave)
    end
end
