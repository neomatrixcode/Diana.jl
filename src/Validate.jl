include("Visitor.jl")
include("rules/consultas.jl")
include("rules/schema.jl")


function deepquery(documentAST)
	gd =getdeep()
    visitante(documentAST,gd)
    return gd.valordeep()
end

function Validatequery(documentAST)
	queryRules=[NotExtensionOnOperation(),#=NotTypeOnOperation(),=#NotSchemaOnOperation(),FragmentSubscription(),FragmentNames(),OperationNames(),OperationAnonymous(),SubscriptionFields(),FragmentUnknowNotUsed(),FragmentCycles()]
    vi= Visitante(documentAST)
	vi.visitante.(queryRules)
	return "ok"
end

function gettypes(schema)
	gt=getfield_types()
    visitante(schema,gt)
    return gt.notbasic_types
end

