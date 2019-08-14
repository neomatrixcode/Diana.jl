struct getfield_types <:Rule
	enter::Function
	leave::Function
	simbolos::Dict
    tipos::Dict
	function getfield_types()
		simbolos= Dict()
		tipos= Dict()
		nombre=""
		function enter(node)
			if (node.kind == "ObjectTypeDefinition")
				 nombre = node.name.value
                 push!(tipos, nombre => Dict())
			end
			if (node.kind == "FieldDefinition")
                 push!(tipos[nombre], node.name.value => Dict("tipo" =>node.tipe.name.value ) )
			end
			if (node.kind == "OperationTypeDefinition")
				push!(simbolos, node.operation => Dict("tipo" =>node.tipe.name.value ))
			end
		end
		function leave(node)
		end
		new(enter,leave,simbolos,tipos)
	end
end