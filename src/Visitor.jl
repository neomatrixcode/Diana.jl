#=julia> f(x,y)= y(x)
f (generic function with 1 method)

julia> A=[(x)->x+1,(x)->x+2]
2-element Array{Function,1}:
 getfield(Main, Symbol("##9#11"))()
 getfield(Main, Symbol("##10#12"))()

julia> f.(1,A)
2-element Array{Int64,1}:
 2
 3=#

function visitante(x::Node,rules)
	t = typeof(x)

	try
	rules.rule(x)
    catch e

    	if isa(e,GraphqlError)
    		return throw(e)
    	end
    	if !isa(e,MethodError)
    		return throw(e)
    	end
    end

	for f in fieldnames(t)
		#=if(f == :value) #|| (f == :operation)
			println("	holo XD  ")
		end=#
		if( typeof(getfield(x, f) )<: Node)
			visitante(getfield(x, f),rules)
		elseif (typeof(getfield(x, f)) <: Array)
		    visitante(getfield(x, f),rules)
		end

	end
	#println("leave ", x.kind )
end

function visitante(x::Array,f)
    for c in x
    	if (typeof(c) <: Node)
		visitante(c,f)
	    else
	    	break
    	end
	end
end