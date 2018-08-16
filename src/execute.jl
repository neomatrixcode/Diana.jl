struct resol
	exec_root
	exec_foil
	function resol(resolvers)
		n_campos=["query","persona","neomatrix"]
		tipos   =["Query","Persona","Persona"]
		ctx = Dict()
		arg = Dict()
		executed =[]
		function exec_root(nombrecampo,raiz)# neomatrix, query
			nombretipo= tipos[findfirst(isequal(nombrecampo), n_campos)]
			tiporaiz = tipos[findfirst(isequal(raiz), n_campos)]
			ctx[nombretipo] = resolvers[tiporaiz*"_"*nombrecampo](ctx)
		end

		function exec_foil(nombrecampo,raiz)# nombre, neomatrix
			tiporaiz= tipos[findfirst(isequal(raiz), n_campos)]
			return resolvers[tiporaiz*"_"*nombrecampo](ctx[tiporaiz])
		end
		new(exec_root,exec_foil)
	end
end


struct executor
	enter
	leave
	salida
	function executor(exec_resol)
		nivel=1
		salida=Dict()
		salida["datos"]=Dict()
		ex= :($salida["datos"])
		expresiones = Array{Expr}(undef, 4)
		expresiones[1]= ex
		nombres=Array{String}(undef, 4)
		nombres[1]="query"
		function enter(node)
			if (node.kind=="Field")
				if (typeof(node.selectionSet)<:Node)
					nivel = nivel+1
					ncampo= node.name.value
					exp = expresiones[nivel-1]
					exp= :(($exp)[$(ncampo)])
					expresiones[nivel]= exp
					nombres[nivel] = ncampo
					eval(:(($exp)=Dict()))
					exec_resol.exec_root(ncampo,nombres[nivel-1])
				else
					exp = expresiones[nivel]
					campo = node.name.value
					exp= :(($exp)[$(campo)])
					resolve = exec_resol.exec_foil(campo,nombres[nivel])
					eval(:(($exp)=$(resolve)))
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

function ExecuteQuery(query, myresolvers)
	exec= executor(resol(myresolvers))
	visitante(query,exec)
	return exec.salida
end