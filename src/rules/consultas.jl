
struct GraphqlError <: Exception
           msg
       end

function NotExtensionOnOperation(node::TypeExtensionDefinition)
		return throw(GraphqlError("GraphQL cannot execute a request containing a TypeExtensionDefinition."))
end

function NotTypeOnOperation(node::ObjectTypeDefinition)
	return throw(GraphqlError("GraphQL cannot execute a request containing a ObjectTypeDefinition."))
end

function NotSchemaOnOperation(node::SchemaDefinition)
	return throw(GraphqlError("GraphQL cannot execute a request containing a SchemaDefinition."))
end
