include("Visitor.jl")
include("rules/consultas.jl")

import Base.length
function length(x::Node)
       return 1
end

function Base.iterate(l::Node)
    return l
end

function Base.iterate(l::Node, isdone::Any)
    return l
end

function Validatequery(documentAST)
	queryRules=[NotExtensionOnOperation(),NotTypeOnOperation(),NotSchemaOnOperation(),FragmentSubscription(),FragmentNames(),OperationNames(),OperationAnonymous(),SubscriptionFields(),FragmentUnknowNotUsed(),FragmentCycles()]

	try
	visitante.([documentAST],queryRules)
	return "ok"
	catch e
        s=string(e.msg)
        #println(s)
        return """{
				  \"data\": null,
				  \"errors\": [
				    {
				      \"message\": $(s)
				    }
				  ]
				}"""
      end
end
