mutable struct visitor
	enter
	leave
end

function visitante(x::Node)
	t = typeof(x)::DataType
	println("Enter ", x.kind)
	for i in 1:nfields(x)
		f = fieldname(t, i)
		tipo = typeof((getfield(x, f)))
		if(f == :value) #|| (f == :operation)
			println("	holo XD  ")
		end
		if (tipo <: Node || tipo <: Array)
			visitante(getfield(x, f))
		end
	end
	println("leave ", x.kind )
end

function visitante(x::Array)
    for c in x
     	visitante(c)
     end
end