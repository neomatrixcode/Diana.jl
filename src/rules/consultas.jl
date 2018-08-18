
struct GraphqlError <: Exception
           msg
       end


struct getdeep
	enter
	leave
	valordeep
	function getdeep()
		valor=1
		nivel=1
		function valordeep()
			return valor
		end
		function enter(node)
			if (node.kind=="Field")
				if (typeof(node.selectionSet)<:Node)
					nivel = nivel+1
					if(nivel>valor)
						valor = nivel
					end
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
		new(enter,leave,valordeep)
	end
end

struct NotExtensionOnOperation
	enter
	leave
	function NotExtensionOnOperation()
		function enter(node)
			if (node.kind== "TypeExtensionDefinition")
				return throw(GraphqlError("GraphQL cannot execute a request containing a TypeExtensionDefinition."))
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end

struct NotTypeOnOperation
	enter
	leave
	function NotTypeOnOperation()
		function enter(node)
			if (node.kind== "ObjectTypeDefinition")
				return throw(GraphqlError("GraphQL cannot execute a request containing a ObjectTypeDefinition."))
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end

struct NotSchemaOnOperation
	enter
	leave
	function NotSchemaOnOperation()
		function enter(node)
			if (node.kind== "SchemaDefinition")
				return throw(GraphqlError("GraphQL cannot execute a request containing a SchemaDefinition."))
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end


struct FragmentSubscription
	enter
	leave
	function FragmentSubscription()
		function enter(node)
			if (node.kind== "FragmentDefinition")
				if (node.typeCondition[2].name.value == "Subscription")

					if (length(node.selectionSet.selections)>1)
						return throw(GraphqlError("subscription must select only one top level field"))
					end
				end
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end


struct FragmentNames
	enter
	leave
	function FragmentNames()
		nombres=[]
		function enter(node)
			if (node.kind== "FragmentDefinition")
				valor= node.name.value
				if(valor in nombres)
					return throw(GraphqlError("There can only be one fragment named \'$(valor)\'."))
				else
					push!(nombres,valor)
				end
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end

struct OperationNames
	enter
	leave
	function OperationNames()
		nombres=[]
		function enter(node)
			if (node.kind== "OperationDefinition")
				valor= node.name
				if (typeof(valor)<: Name)
					valor= valor.value
					if(valor in nombres)
						return throw(GraphqlError("There can only be one operation named \'$(valor)\'."))
					else
						push!(nombres,valor)
					end
				end
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end

struct OperationAnonymous
	enter
	leave
	function OperationAnonymous()
		n_operation = 0
		anonimo= false
		function enter(node)
			if (node.kind== "OperationDefinition")
				valor = node.name
				n_operation=n_operation+1
				if !(typeof(valor)<: Name)
					anonimo=true
				end
				if ((anonimo== true) && (n_operation>1))
					return throw(GraphqlError("This anonymous operation must be the only defined operation."))
				end
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end

struct SubscriptionFields
	enter
	leave
	function SubscriptionFields()
		function enter(node)
			if (node.kind== "OperationDefinition")
				if (node.operation == "subscription")
					if (length(node.selectionSet.selections)>1)
						return throw(GraphqlError("subscription must select only one top level field"))
					end
				end
			end
		end
		function leave(node)

		end
		new(enter,leave)
	end
end


struct FragmentUnknowNotUsed
	enter
	leave
	function FragmentUnknowNotUsed()
		nombres=[]
		usados=[]
		yausados=[]
		texto = ""
		function enter(node)
			if (node.kind== "FragmentSpread") #usados
				nombre = node.name.value
				if( nombre in nombres)
					deleteat!(nombres,findfirst(isequal(nombre), nombres))
				else
					if !(nombre in yausados)
					push!(usados,nombre)
					end
				end
			end
			if (node.kind== "FragmentDefinition")
				valor= node.name.value
				if(valor in usados)
					deleteat!(usados,findfirst(isequal(valor), usados))
					if(!(valor in yausados))
					    push!(yausados,valor)
					end
				else
					push!(nombres,valor)
				end
			end
		end
		function leave(node)
			if (node.kind=="Document")
				if (length(nombres)>0)
				  for n in nombres
				      texto=texto*" "*n
				  end
				  return throw(GraphqlError("Fragment$(texto) is not used."))
				end
				if (length(usados)>0)
				    for n in usados
				      texto=texto*" "*n
				    end
 				  return throw(GraphqlError("Unknown fragment$(texto)."))
				end
			end
		end
		new(enter,leave)
	end
end


struct FragmentCycles
	enter
	leave
	function FragmentCycles()
		nombrescycles=[]
		usadoscycles=[]
		inicio = ""
		traza = ""
		leerspread =false
		function enter(node)
			if (node.kind== "FragmentSpread") #usadoscycles
				if (leerspread == true)
				nombre = node.name.value
				push!(usadoscycles,nombre)
				end
			end

			if (node.kind== "FragmentDefinition")
				leerspread =true
				valor= node.name.value
				push!(nombrescycles,valor)
			end
		end

		function leave(node)
			if (node.kind== "FragmentDefinition")
				leerspread =false
			end
			if (node.kind=="Document")
				if (length(nombrescycles)>0)
				if (length(nombrescycles)==length(usadoscycles))
					inicio = nombrescycles[1]
					for l in nombrescycles[2:end]
					    traza=traza*" "*l
					end
				    return throw(GraphqlError("Cannot spread fragment $(inicio) within itself via $(traza)."))
				end
				end
			end
		end
		new(enter,leave)
	end
end
