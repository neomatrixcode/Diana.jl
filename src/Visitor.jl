
function visitante(x::Node,rules)
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