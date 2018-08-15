struct executor
	enter
	leave
	salida
	function executor()
		nivel=1
		salida=Dict()
		salida["datos"]=Dict()
		ex= :($salida["datos"])
		expresiones = Array{Expr}(undef, 4)
		expresiones[1]= ex
		function enter(node)
			if (node.kind=="Field")
				if (typeof(node.selectionSet)<:Node)
					nivel = nivel+1
					exp = expresiones[nivel-1]
					exp= :(($exp)[$(node.name.value)])
					expresiones[nivel]= exp
					eval(:(($exp)=Dict()))
				else
					exp = expresiones[nivel]
					exp= :(($exp)[$(node.name.value)])
					eval(:(($exp)="resolve"))
				end
			end
		end
		function leave(node)
			if (node.kind=="Field")
				if (typeof(node.selectionSet)<:Node)
					nivel = nivel-1
				end
			end
		end
		new(enter,leave,salida)
	end
end

function ExecuteQuery(query, resolvers)
	exec= executor()
	visitante(query,exec)
	return exec.salida
end