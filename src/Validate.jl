include("Visitor.jl")
include("rules/consultas.jl")
"""
    Validatequery(documentAST::Node)

Válida que el AST de la consulta no tenga errores de sintaxis. Validatequery(Parse(query::String))
"""
function Validatequery(documentAST::Node)
	queryRules=[NotExtensionOnOperation(),NotTypeOnOperation(),NotSchemaOnOperation(),FragmentSubscription(),FragmentNames(),OperationNames(),OperationAnonymous(),SubscriptionFields(),FragmentUnknowNotUsed(),FragmentCycles()]
    vi= Visitante(documentAST)
	vi.visitante.(queryRules)
	return "ok"
end

