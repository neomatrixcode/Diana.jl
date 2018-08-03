mutable struct visitor
	enter
	leave
end

function visitante(x::Node)
	t = typeof(x)#::DataType
	println("Enter ", x.kind)
	for f in fieldnames(t)
		if(f == :value) #|| (f == :operation)
			println("	holo XD  ")
		end
		try
			visitante(getfield(x, f))
		catch
		end
	end
	println("leave ", x.kind )
end

function visitante(x::Array)
    for c in x
     	visitante(c)
     end
end