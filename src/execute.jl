
struct ExecuteField <:Rule
	enter::Function
	leave::Function
	result::Dict

	function ExecuteField(symbol_table, resolvers)
        padre="Query"
        ctx=nothing
        result=Dict("data" => Dict() )

		function resolvefieldValue(nombrecampo)#objectType , objectValue , fieldName , argumentoValues=nothing )
				if haskey(resolvers[padre], nombrecampo)
					return resolvers[padre][nombrecampo](ctx)
				elseif typeof(ctx)<:Dict# si ctx es un diccionario
			        return ctx[nombrecampo]
			    else
					return ctx
				end

		end

		function resolvefield(ctx)#objectType, objectValue, fieldType, fields, variableValues=nothing, ctx=nothing)

			#=if ([field]["tipo"] == "List")
				#paralelo
				ctx= resolve["padre"]["campo"](ctx)

				for i in ctx
				    salida = resolvefield(i)
				end
				return "nombrecampo" => [salida]
			end=#
		  #CompleteValue ( FieldType , campos , resolvedValue , variableValues ) #verifica que el tipo del valor devuelto coincida con el del esquema
		end

		function enter(node::Node)
            if (node.kind == "Field")
            	tipoactual= symbol_table[padre][node.name.value]["tipo"]
            		if ((tipoactual == "String") | (tipoactual == "Float") || (tipoactual == "Int") || (tipoactual == "Boolean")   )
			        	push!(result["data"], node.name.value => resolvefieldValue(node.name.value) )
			        else
			        	ctx= resolvers[padre][node.name.value](ctx)
			        	padre= tipoactual
	                end
            end
		end

		function leave(node)
            if (node.kind == "Field")

            end
		end

		new(enter,leave,result)

    end


end
#=function ExecuteSelectionSet( selectionSet , objectType , objectValue , variableValues=nothing )
resultMap  = Dict()

#groupfieldset = CollectFields(selectionSet)

#en paralelo
for field in selectionSet
    resulmap = Dict(nombrecampo => ExecuteField ( objectType , objectValue , field , fieldType ))
end

return resultMap
 end
=#

function ExecuteQuery(operation::Node, symbol_table::Dict, resolvers, coercedVariableValues=nothing, initialValue=nothing)
    #ExecuteSelectionSet()
    resultexec =ExecuteField(symbol_table,resolvers)
    vi= Visitante(operation)
    vi.visitante(resultexec)
    return resultexec.result
end

function ExecuteMutation(operation::Node, symbol_table::Dict, coercedVariableValues=nothing, initialValue=nothing)

end

function Subscribe(operation::Node, symbol_table::Dict, coercedVariableValues=nothing, initialValue=nothing)

end