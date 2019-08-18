#=
struct ExecuteFieldParallel
	#enter::Function
	#leave::Function
	result::Dict

	function ExecuteFieldParallel(resolvers)
      result=Dict()
		function strands_execution(strand)
			#=

			 query{
	      event{
	        attends{
	          name
	        }
	      }
        }

			la hebra seria:  query - event - attends - name
			se ejecuta el resolve   resolve["event"]["attends"] -> se alamacena el resultado en una cache para evitar
			que se ejecuten muchas veces la misma consulta
			si ya tienes los datos solo pasalos

			y se pasa a la hoja "name" en lo campo root para la ejecucion de la hoja
			se evita la ejecucion del resolve  resolve["query"]["event"]

            soluciona el Multi-layered data fetching

			aun pienso en como resolver el n+1 con este mismo enfoque


	    query{
	      event{ -> []
	      	name
	        attends{ -> []
	          name
	        }
	      }
        }

			tal vez :

			query - event - name =>  toda la tabla event

			 query - event - attends - name => toda la tabla attends

			 y despues que se fusionen los datos, pero quien sabe
			=#
		end

		new(result)

    end


end
=#

struct ExecuteField
    visitante
    datos::Dict

    function ExecuteField(symbol_table::Dict, resolvers::Dict,ctx; Variables=nothing)
    	global datos=Dict("data"=>Dict())


    	function resolvefieldValue(nombrecampo::String,args::Dict,type_padre::String,root::Union{Nothing,Dict},path::String,tipoactual::String)
				if (haskey(resolvers, type_padre)) && (haskey(resolvers[type_padre], nombrecampo))
						return resolvers[type_padre][nombrecampo](root,args,ctx,Dict("fieldName"=>nombrecampo,"parentType"=>type_padre,"path"=>path,"dato=Type"=> tipoactual))
				elseif (typeof(root)<:Dict) # si root es un diccionario
			        	return root[nombrecampo]
			    else
					return "null"
				end
		end

    	function mivisitante(x::Array{Node,1},path::String,type_padre::String,root::Union{Nothing,Dict})
    		for c in x
		     mivisitante(c,path,type_padre,root)
			end
		end

		function mivisitante(node::Node,path::String,type_padre::String,root::Union{Nothing,Dict})
			t = typeof(node)

            if (node.kind == "Field")

            	nombre_nodo = node.name.value
            	tipoactual= ""

            	    if (haskey(symbol_table[type_padre], nombre_nodo))
			        	tipoactual= symbol_table[type_padre][nombre_nodo]["tipo"]
			        else
			        	throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"The $(nombre_nodo) field does not exists.\"}]}"))
					end

                args=Dict()
			        			if length(node.arguments)>0
			        			   for data in node.arguments
			        			   	if typeof(data.value[2])<:Diana.Object_
			        			   		push!(args, data.name.value => Dict() )
			        			   		for i in data.value[2].fields
			        			   		    if typeof(i.value[2])<:Diana.Variable
			        			   		    	push!(args[data.name.value], i.name.value => Variables[i.value[2].name.value] )
			        			   			else
			        			   		    	push!(args[data.name.value], i.name.value => i.value[2].value )
			        			   			end
			        			   		end
			        			   	else
			        			   			if typeof(data.value[2])<:Diana.Variable
			        			   		    	push!(args, data.name.value => Variables[data.value[2].name.value] )
			        			   			else
			        			   		    	push!(args, data.name.value => data.value[2].value )
			        			   			end
			        			   	end
			        			   end
			        		    end

            		if ((tipoactual == "String") | (tipoactual == "ID"))
            			eval(Meta.parse("push!(datos$(path), \"$(nombre_nodo)\" => \"$(resolvefieldValue(nombre_nodo,args,type_padre,root,path,tipoactual))\")"))
            		elseif ( (tipoactual == "Float") | (tipoactual == "Int") | (tipoactual == "Boolean"))
                             eval(Meta.parse("push!(datos$(path), \"$(nombre_nodo)\" => $(resolvefieldValue(nombre_nodo,args,type_padre,root,path,tipoactual)))"))
			        else # el tipo lista [ ] apenas lo pondre

			        	if (haskey(resolvers, type_padre)) && (haskey(resolvers[type_padre], nombre_nodo))

                                root= resolvers[type_padre][nombre_nodo](nothing,args,ctx,Dict("fieldName"=>nombre_nodo,"parentType"=>type_padre,"path"=>path,"returnType"=> tipoactual))
			  	        end

						if !(nombre_nodo in collect(keys(eval(Meta.parse("datos$(path)")))))
            				eval(Meta.parse("push!(datos$(path), \"$(nombre_nodo)\"=>Dict())"))
                        end

            			path= path*"[\"$(nombre_nodo)\"]"
			  	        type_padre= tipoactual

	                end
            end


			for f in fieldnames(t)
				subarbol= getfield(node, f)
				if( (typeof(subarbol )<: Node) & !(isa(subarbol, Diana.Name) ) )
					mivisitante(subarbol,path,type_padre,root)
				elseif (typeof(subarbol) <: Array{Node,1})
				    mivisitante(subarbol,path,type_padre,root)
				end
			end
			#rules.leave(x)
		end

	    function visitante(ast::Node, raiz::String)
			mivisitante(ast,"[\"data\"]",raiz,nothing)
	    end
      new(visitante,datos)
    end
end


function ExecuteQuery(operation::Node, symbol_table::Dict, resolvers::Dict,context; Variables=nothing, initialValue=nothing)
    resultexec = ExecuteField(symbol_table,resolvers,context,Variables=Variables)
    resultexec.visitante(operation,symbol_table["query"])
    return resultexec.datos
end

function ExecuteMutation(operation::Node, symbol_table::Dict, resolvers::Dict,context; Variables=nothing, initialValue=nothing)
	resultexec = ExecuteField(symbol_table,resolvers,context,Variables=Variables)
    resultexec.visitante(operation,symbol_table["mutation"])
    return resultexec.datos
end

#function Subscribe(operation::Node, symbol_table::Dict; Variables=nothing, initialValue=nothing)

#end



#function ExecuteQueryParallel(operation::Node, symbol_table::Dict, resolvers; Variables=nothing, initialValue=nothing)

#end
