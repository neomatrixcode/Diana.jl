include("Visitor.jl")
include("rules/consultas.jl")
include("rules/schema.jl")

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

function deepquery(documentAST)
	gd =getdeep()
    visitante(documentAST,gd)
    return gd.valordeep()
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

function gettypes(schema)
	gt=getfield_types()
    visitante(schema,gt)
    return gt.notbasic_types
end

