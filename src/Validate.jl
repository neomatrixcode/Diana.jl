include("Visitor.jl")
include("rules/consultas.jl")

function Validatequery(documentAST)
	queryRules=[NotExtensionOnOperation(),NotTypeOnOperation(),NotSchemaOnOperation(),FragmentSubscription(),FragmentNames(),OperationNames(),OperationAnonymous(),SubscriptionFields(),FragmentUnknowNotUsed(),FragmentCycles()]
    vi= Visitante(documentAST)
	vi.visitante.(queryRules)
	return "ok"
end

