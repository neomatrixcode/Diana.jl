struct getfield_types <:Rule
	enter
	leave
	basic_types
	notbasic_types
	function getfield_types()
		scalars_types=["String", "Int", "Float", "Boolean"]
		basic_types=[[],[]]
		notbasic_types=[[],[]]
		function enter(node)
			if (node.kind == "FieldDefinition")
				thetype = node.tipe.name.value
					  #=if parse_schema == true
    if !haskey(tabla_simbolos,buffer)
              push!(tabla_simbolos, name.value => Dict("tipo" =>tipe.name.value ))
    end
  end=#
				if(thetype in scalars_types)
				    push!(basic_types[1],node.name.value)
				    push!(basic_types[2],thetype)
				else
					push!(notbasic_types[1],node.name.value)
				    push!(notbasic_types[2],thetype)
				end
			end
			if (node.kind == "OperationTypeDefinition")
				push!(notbasic_types[1],node.operation)
				push!(notbasic_types[2],node.tipe.name.value)
				#=if parse_schema == true
    if !haskey(tabla_simbolos,buffer)
              push!(tabla_simbolos, operation => Dict("tipo" =>tipe.name.value ))
    end
  end=#
			end
		end
		function leave(node)
		end
		new(enter,leave,basic_types,notbasic_types)
	end
end