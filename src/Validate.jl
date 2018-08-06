include("Visitor.jl")
include("rules/consultas.jl")

#queryRules=[NotExtensionOnOperation,NotTypeOnOperation,NotSchemaOnOperation]

function visitInParallel(documentAST)
	rules = Rules()
	try
	visitante(documentAST,rules)
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
