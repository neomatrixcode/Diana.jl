include("Visitor.jl")
include("rules/consultas.jl")

queryRules=[NotExtensionOnOperation,NotTypeOnOperation,NotSchemaOnOperation]

function visitInParallel(documentAST)
	try
	visitante.(documentAST,queryRules)
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
