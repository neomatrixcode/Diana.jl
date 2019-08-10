struct Visitante
    visitante

    function Visitante(ast)

    	function mivisitante(x::Array{Diana.Node,1},rule::Rule)
    		#pmap(mivisitante, x)
    		Threads.@threads for i = 1:length(x)
		    @simd for c in x
				   mivisitante(c,rule)
			     end
			end
		end

		function mivisitante(x::Node,rules::Rule)
			t = typeof(x)
			rules.enter(x)
			for f in fieldnames(t)
				subarbol= getfield(x, f)
				if( typeof(subarbol )<: Node)
					mivisitante(subarbol,rules)
				elseif (typeof(subarbol) <: Array{Diana.Node,1})
				    mivisitante(subarbol,rules)
				end
			end
			rules.leave(x)
		end

	    function visitante(rule::Rule)
			mivisitante(ast,rule)
	    end
      new(visitante)
    end
end


#=function visitante(x::Node,rules)
	t = typeof(x)
	rules.enter(x)
	for f in fieldnames(t)
		if( typeof(getfield(x, f) )<: Node)
			visitante(getfield(x, f),rules)
		elseif (typeof(getfield(x, f)) <: Array)
		    visitante(getfield(x, f),rules)
		end
	end
	rules.leave(x)
end=#

#=function visitante(x::Array,f)
    for c in x
    	if (typeof(c) <: Node)
		visitante(c,f)
	    else
	    	break
    	end
	end
end=#