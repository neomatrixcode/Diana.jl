struct Visitante
    visitante

    function Visitante(ast::Node)

    	function mivisitante(x::Array{Node,1},rule::Rule)
    		for c in x
		     mivisitante(c,rule)
			end
		end

		function mivisitante(x::Node,rules::Rule)
			t = typeof(x)
			rules.enter(x)
			for f in fieldnames(t)
				subarbol= getfield(x, f)
				if( (typeof(subarbol )<: Node) & !(isa(subarbol, Diana.Name) ) )
					mivisitante(subarbol,rules)
				elseif (typeof(subarbol) <: Array{Node,1})
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





#=
struct VisitanteParallel
    visitante

    function VisitanteParallel(ast::Node)

    	function mivisitante(x::Array{Node,1},rule::Rule)
    		for c in x  # paralelizacion
		     mivisitante(c,rule)
			end
		end

		function mivisitante(x::Node,rules::Rule)
			t = typeof(x)
			rules.enter(x)
			for f in fieldnames(t)  # paralelizacion
				subarbol= getfield(x, f)
				if( (typeof(subarbol )<: Node) & !(isa(subarbol, Diana.Name) ) )
					mivisitante(subarbol,rules)
				elseif (typeof(subarbol) <: Array{Node,1})
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
end=#