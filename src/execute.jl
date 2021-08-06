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
    visitante::Function
    datos::Dict

    function ExecuteField(symbol_table::NamedTuple, resolvers::NamedTuple,ctx; Variables=nothing)
    	datos=Dict("data"=>Dict())

		function resolve_field(args,ctx,type_padre::Symbol, father_type::NamedTuple, nombre_nodo::Symbol, root::NamedTuple)
			#println(" resolve_field de NamedTuple ")

			if ((father_type[nombre_nodo][:resolver]) === nothing)
				if (haskey(root, nombre_nodo))
						return getfield(root,nombre_nodo)
				else
					throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"The "*String(nombre_nodo)*" field does not exists.\"}]}"))
				end
			else
				return father_type[nombre_nodo][:resolver](root, args, ctx, (fieldName = nombre_nodo, parentType = type_padre))
				#datatable = merge(datatable, NamedTuple{(Symbol(String(nombre_nodo)),)}((root,)))
			end
		end

		function resolve_field(args,ctx,type_padre::Symbol, father_type::NamedTuple, nombre_nodo::Symbol, root::H) where {H} 
			#println(" resolve_field de objetos ")
			if ((father_type[nombre_nodo][:resolver]) === nothing)
				if (nombre_nodo in fieldnames(typeof(root)))
						return getfield(root,nombre_nodo)
				else
					throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"The "*String(nombre_nodo)*" field does not exists.\"}]}"))
				end
			else
				return father_type[nombre_nodo][:resolver](root, args, ctx, (fieldName = nombre_nodo, parentType = type_padre))
				#datatable = merge(datatable, NamedTuple{(Symbol(String(nombre_nodo)),)}((root,)))
			end
		end


		function resolve_field(args,ctx,type_padre::Symbol, father_type::NamedTuple, nombre_nodo::Symbol, root::Dict)
			#println(" resolve_field de Diccionarios ")

			if ((father_type[nombre_nodo][:resolver]) === nothing)
				if (haskey(root, nombre_nodo))
					return root[nombre_nodo]
				else
					throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"The "*String(nombre_nodo)*" field does not exists.\"}]}"))
				end
			else
				return father_type[nombre_nodo][:resolver](root, args, ctx, (fieldName = nombre_nodo, parentType = type_padre))
				#datatable = merge(datatable, NamedTuple{(Symbol(String(nombre_nodo)),)}((root,)))
			end
		end

		function extract_arguments(node)
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
		end

		function runner(subarbol,type_padre::Symbol,root::H) where {H}
			if( (typeof(subarbol )<: Node) )
				mivisitante(subarbol,type_padre,root)
			elseif (typeof(subarbol) <: Array{Node,1})
				iterate(Iterators.map((campo) -> mivisitante(campo,type_padre,root), subarbol))
			end 
		end

		function mivisitante(node::Node,type_padre::Symbol, root::H) where {H}
			typeofnode = typeof(node)
			args = Dict()
			ctx=""
			
            if (node.kind == "Field")
			
            	nombre_nodo::Symbol = Symbol(node.name.value)
				father_type = getfield(symbol_table,type_padre)

            	if (haskey(father_type, nombre_nodo))

			        tipoactual::Symbol = father_type[nombre_nodo][:tipo]
                    
					#extract_arguments()

					if (father_type[nombre_nodo][:primitivo] == true)

						#= if (haskey(root, nombre_nodo_string))
							println("valor -> ",root[nombre_nodo_string])
						else
							throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"The "*String(nombre_nodo)*" field does not exists.\"}]}"))
						end =#
                    
							#println(nombre_nodo, " es un ", tipoactual)
							#= if ((tipoactual == :String ) | (tipoactual == :ID))
								println(nombre_nodo, " es string o ID ")
									# eval(Meta.parse("push!(datos$(path), \"$(nombre_nodo)\" => \"$(resolvefieldValue(nombre_nodo,args,type_padre,root,path,tipoactual))\")"))
							elseif ( (tipoactual == :Float ) | (tipoactual == :Int) | (tipoactual == :Boolean ))
								println(nombre_nodo, " es Float, Int o Boolean")
									# eval(Meta.parse("push!(datos$(path), \"$(nombre_nodo)\" => $(resolvefieldValue(nombre_nodo,args,type_padre,root,path,tipoactual)))"))
							# el tipo lista [ ] apenas lo pondre
							end  =#
					else 
							
		                root = resolve_field(args,ctx,type_padre,father_type,nombre_nodo, root)
						type_padre= tipoactual
		
					end
			    else
			        throw(GraphQLError("{\"data\": null,\"errors\": [{\"message\": \"The "*String(nombre_nodo)*" field does not exists.\"}]}"))
				end 
				
            end 

			iterate(Iterators.map((field)->runner(getfield(node,field),type_padre,root), fieldnames(typeofnode)))	
		end


	    function visitante(ast::Node, raiz::Symbol)
			
			#println(ast)
			mivisitante(ast,raiz, NamedTuple())
	    end
      new(visitante,datos)
    end
end


function ExecuteQuery(operation::Node, symbol_table::NamedTuple, resolvers::NamedTuple,context; Variables=nothing, initialValue=nothing)
    resultexec = ExecuteField(symbol_table,resolvers,context,Variables=Variables)
    resultexec.visitante(operation,symbol_table.query)
    return resultexec.datos
end

function ExecuteMutation(operation::Node, symbol_table::NamedTuple, resolvers::NamedTuple,context; Variables=nothing, initialValue=nothing)
	resultexec = ExecuteField(symbol_table,resolvers,context,Variables=Variables)
    resultexec.visitante(operation,symbol_table.mutation)
    return resultexec.datos
end

#function Subscribe(operation::Node, symbol_table::NamedTuple; Variables=nothing, initialValue=nothing)

#end



#function ExecuteQueryParallel(operation::Node, symbol_table::NamedTuple, resolvers; Variables=nothing, initialValue=nothing)

#end

#  @btime my_schema.execute(query)
# 9.379 ms (1097 allocations: 50.86 KiB)
# 5.701 ms (1135 allocations: 52.44 KiB)
# 6.674 ms (1132 allocations: 52.39 KiB)
# 5.974 ms (1143 allocations: 52.73 KiB)
# 5.892 ms (1168 allocations: 53.19 KiB)
# 4.964 ms (1088 allocations: 50.47 KiB)
# 72.800 μs (869 allocations: 43.20 KiB)
# 72.399 μs (869 allocations: 43.20 KiB)
# 74.200 μs (925 allocations: 45.44 KiB)
# 73.800 μs (913 allocations: 44.91 KiB)
# 73.600 μs (905 allocations: 44.41 KiB)
# 83.300 μs (991 allocations: 53.97 KiB)
# 206.800 μs (2514 allocations: 136.63 KiB)
# 206.600 μs (2499 allocations: 134.72 KiB)