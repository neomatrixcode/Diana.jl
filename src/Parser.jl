#  return the ast o un syntax error, unexpected IDENTIFIER, expecting fragment or mutation or query or { on line
abstract type Node end
struct Document <:Node
	kind::String
  definitions
  Document(d)=new("Document",d)
end

struct OperationDefinition <:Node
	kind::String
	operation::String
	name
	variableDefinitions
	directives
	selectionSet
	OperationDefinition(op,name,vardef,direc,selec)=new("OperationDefinition",op,name,vardef,direc,selec)
end
struct SelectionSet <:Node
	kind::String
	selections
	#loc
	SelectionSet(sel) = new("SelectionSet",sel)
end
struct Name <:Node
	kind::String
	value::String
	#loc
	Name(val)= new("Name",val)
end
struct Argument <:Node
	kind::String# "Argument";
	name::Name
	value #[ Literal | Variable | Reference ];
	#loc
	Argument(n::Name,x)= new("Argument",n,x)
end
struct VariableDefinition <:Node
	kind::String
	variable
	tipe
	defaultValue
	#loc
	VariableDefinition(va,tipe,defval)=new("VariableDefinition",va,tipe,defval)
end
struct Variable <:Node
	kind::String# "Variable";
	name
	Variable(n)= new("Variable",n)
end
struct FragmentSpread <:Node
	kind::String
	name
	directives
	#loc
	FragmentSpread(n,d)=new("FragmentSpread",n,d)
end
struct InlineFragment <:Node
	kind::String
	typeCondition
	directives
    selectionSet
    #loc
    InlineFragment(typecon,direc,selset)=InlineFragment("InlineFragment",typecon,direc,selset)
end
struct FragmentDefinition <:Node
	kind::String
	name
	typeCondition
		directives
		selectionSet
		#loc
		FragmentDefinition(n,t,d,s)=new("FragmentDefinition",n,t,d,s)
	end
struct IntValue <:Node
	kind::String
	value
	#loc
	IntValue(v)=new("IntValue",v)
end
struct FloatValue <:Node
	kind::String
	value
	#loc
	FloatValue(v)=new("FloatValue",v)
end
struct StringValue <:Node
	kind::String
	value
	#loc
	StringValue(v)=new("StringValue",v)
end
struct BooleanValue <:Node
	kind::String
	value
	#loc
	BooleanValue(v)=new("BooleanValue",v)
end
struct NullValue <:Node
	kind::String
	#loc
	NullValue()=new("NullValue")
end
struct EnumValue <:Node
	kind::String
	value
	#loc
	EnumValue(v)=new("EnumValue",v)
end
struct List_ <:Node
	kind::String
	value_s
	#loc
	List_(vals)=new("List",vals)
end
struct Object_ <:Node
	kind::String
	fields
	#loc
	Object_(f)=new("Object",f)
end
struct Object_Field <:Node
	kind::String
	name
	value
	#loc
	Object_Field(n,v)=new("Object_Field",n,v)
end
struct Directive <:Node
	kind::String
	name
	arguments
	#loc
	Directive(n,a) = new("Directive",n,a)
end
struct ListType <:Node
    kind::String
    tipe
    #loc
    ListType(t)=new("ListType",t)
end

struct NonNullType <:Node
    kind::String
    tipe
    #loc
    NonNullType(t)=new("NonNullType",t)
end
struct NamedType <:Node
   kind::String
   name
   #loc
   NamedType(n)=new("NamedType",n)
end
struct SchemaDefinition <:Node
	kind::String
    directives
    operationTypes
    #loc
    SchemaDefinition(d,o)=new("SchemaDefinition",d,o)
end
struct OperationTypeDefinition <:Node
    kind::String
    operation
    tipe
    #loc
    OperationTypeDefinition(o,t)=new("OperationTypeDefinition",o,t)
end
struct ScalarTypeDefinition <:Node
    kind::String
    name
    directives
    #loc
    ScalarTypeDefinition(n,d)=new("ScalarTypeDefinition",n,d)
end
struct ObjectTypeDefinition <:Node
	kind::String
	name
	interfaces
	directives
	fields
	#loc
	ObjectTypeDefinition(n,i,d,f)=new("ObjectTypeDefinition",n,i,d,f)
end
struct FieldDefinition <:Node
	kind::String# "Field";
	name
	arguments
	tipe
    directives
    #loc
	FieldDefinition(n,arg,ti,dir)= new("FieldDefinition",n,arg,ti,dir)
end

struct Field <:Node
     kind::String
    alias
    name
    arguments
    directives
    selectionSet
    #loc
    Field(a,n,arg,d,s)=new("Field",a,n,arg,d,s)
end
struct InputValueDefinition <:Node
    kind::String
    name
    tipe
    defaultValue
    directives
    #loc
    InputValueDefinition(n,t,dfv,dir)=new("InputValueDefinition",n,t,dfv,dir)
end
struct InterfaceTypeDefinition <:Node
    kind::String
    name
    directives
    fields
    #loc
    InterfaceTypeDefinition(n,d,f)=new("InterfaceTypeDefinition",n,d,f)
end
struct UnionTypeDefinition <:Node
	kind::String
    name
    directives
    tipes
    #loc
    UnionTypeDefinition(n,d,t)=new("UnionTypeDefinition",n,d,t)
end
struct EnumTypeDefinition <:Node
    kind::String
    name
    directives
    _values
    #loc
    EnumTypeDefinition(n,d,v)=new("EnumTypeDefinition",n,d,v)
end
struct EnumValueDefinition <:Node
    kind::String
    name
    directives
    #loc
    EnumValueDefinition(n,d)=new("EnumValueDefinition",n,d)
end
struct InputObjectTypeDefinition <:Node
    kind::String
    name
    directives
    fields
    #loc
    InputObjectTypeDefinition(n,d,f)=new("InputObjectTypeDefinition",n,d,f)
end
struct TypeExtensionDefinition <:Node
    kind::String
    definition
    #loc
    TypeExtensionDefinition(d)=new("TypeExtensionDefinition",d)
end
struct DirectiveDefinition <:Node
    kind::String
    name
    arguments
    locations
    #loc
    DirectiveDefinition()=new("DirectiveDefinition")
end

struct Lexer
    token
    advance
    back
    function Lexer(str)
        lexers =Tokensgraphql(str)

        indice = 1
        fin =  length(lexers)

        function advance()
            if indice<=fin
                indice = indice+1
            end
        end

        function back()
            if indice>1
                indice = indice-1
            end
        end

        function current_token()
            return lexers[indice]
        end
        new(current_token,advance,back)
    end
end


"""
  Determines if the next token is of a given kind
"""
function peek(lexer::Lexer, kind)
  return lexer.token().kind === kind
end

"""
  If the next token is of the given kind, return true after advancing
  the lexer. Otherwise, do not change the parser state and return false.
"""
function next_token(lexer::Lexer, kind)
	check= lexer.token().kind === kind
	if (check)
		lexer.advance()
	end
	return check
end

"""
  If the next token is of the given kind, return that token after advancing
  the lexer. Otherwise, do not change the parser state and throw an error.
"""
function expect(lexer, kind)
	token = lexer.token()

	if (token.kind === kind)
		lexer.advance()
		return token
	end
	return throw(ErrorException("{\"errors\":[{\"locations\": [{\"column\": $(token.startpos[2]),\"line\": $(token.startpos[1])}],\"message\": \"Syntax Error GraphQL request ($(token.startpos[2]):$(token.startpos[1])) Expected $kind, found $token \"}]}"))
end

"""
  If the next token is a keyword with the given value, return that token after
  advancing the lexer. Otherwise, do not change the parser state and return
  false.
"""
function expectKeyword(lexer, value::String)
  token = lexer.token()
  if (token.kind === Tokens.NAME && token.val == value)
    lexer.advance()
    return token
  end
  return throw(ErrorException("Expected $value, found $token in: line $(token.startpos[1]) , col $(token.startpos[2])"))
end

"""
  Helper function for creating an error when an unexpected lexed token
  is encountered.
"""
function unexpected(token)
  return "{\"errors\":[{\"locations\": [{\"column\": $(token.startpos[2]),\"line\": $(token.startpos[1])}],\"message\": \"Syntax Error GraphQL request ($(token.startpos[2]):$(token.startpos[1])) Unexpected character $(token) \"}]}"
end
function unexpected(lexer::Lexer)
  token =lexer.token()
  return "{\"errors\":[{\"locations\": [{\"column\": $(token.startpos[2]),\"line\": $(token.startpos[1])}],\"message\": \"Syntax Error GraphQL request ($(token.startpos[2]):$(token.startpos[1])) Unexpected character $(token) \"}]}"

end

"""
  Returns a possibly empty list of parse nodes, determined by
  the parseFn. This list begins with a lex token of openKind
  and ends with a lex token of closeKind. Advances the parser
  to the next lex token after the closing token.
"""
function an_y(lexer::Lexer, openKind, parseFn::Function, closeKind)
  expect(lexer, openKind)
  nodes = []
  while (!next_token(lexer, closeKind))
    push!(nodes,parseFn(lexer))
  end
  return nodes
end

"""
  Returns a non-empty list of parse nodes, determined by
  the parseFn. This list begins with a lex token of openKind
  and ends with a lex token of closeKind. Advances the parser
  to the next lex token after the closing token.
"""
function many(lexer::Lexer, openKind, parseFn::Function, closeKind)
 	expect(lexer, openKind)
 	nodes = [ parseFn(lexer) ]
 	while (!next_token(lexer, closeKind))
 		push!(nodes,parseFn(lexer))
 	end
 	return nodes
 end
"""
Given a GraphQL source, parses it into a Document.
Throws Diana.GraphQLError if a syntax error is encountered.
 """
function Parse(str)
	return parseDocument(Lexer(str))
end

"""
	#if length(errors)>0
	#	println("Syntax Error GraphQL request (x:x) Unexpected character")
	#	errors
		# {"errors":[{"locations":[{"column":5,"line":3}],"message":"Syntax Error GraphQL request (3:5) Unexpected character \"\".\n\n2:   neomatrix{\n
		3:     nombre\n       ^\n4:     linkedin\n"}]}
  Document : Definition+
"""
 function parseDocument(lexer::Lexer)
 	start_token = lexer.token()
 	definitions = []
 	while true
 		push!(definitions,parseDefinition(lexer))
 		if(next_token(lexer, Tokens.ENDMARKER))
 			break
 		end
 	end
 	return Document(definitions)
 end

"""
  Definition :
    - OperationDefinition
    - FragmentDefinition
    - TypeSystemDefinition
"""
function parseDefinition(lexer::Lexer)
  if (peek(lexer, Tokens.LBRACE))
    return parseOperationDefinition(lexer)
  end

  if (peek(lexer, Tokens.NAME))
      # Note: subscription is an experimental non-spec addition.
      if((lexer.token().val)=="query")
        return parseOperationDefinition(lexer)
      end
      if((lexer.token().val)=="mutation")
        return parseOperationDefinition(lexer)
      end
      if((lexer.token().val)=="subscription")
        return parseOperationDefinition(lexer)
      end

      if((lexer.token().val)=="fragment")
      	return parseFragmentDefinition(lexer)
      end

      # Note: the Type System IDL is an experimental non-spec addition.
      if((lexer.token().val)=="schema")
        return parseTypeSystemDefinition(lexer) end
      if((lexer.token().val)=="scalar")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="type")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="interface")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="union")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="enum")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="input")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="extend")
      return parseTypeSystemDefinition(lexer)
       end
      if((lexer.token().val)=="directive")
      	return parseTypeSystemDefinition(lexer)
      end
    end

  return throw(ErrorException(unexpected(lexer)))
end

"""
	Implements the parsing rules in the Operations section.

  OperationDefinition :
   - SelectionSet
   - OperationType Name? VariableDefinitions? Directives? SelectionSet
"""
function parseOperationDefinition(lexer::Lexer)
  start_token = lexer.token()
  if (peek(lexer, Tokens.LBRACE))
    pSS=parseSelectionSet(lexer)
  	return OperationDefinition("query",nothing,nothing,[],pSS)
  end

  operation = parseOperationType(lexer)
  name = ""
  if (peek(lexer, Tokens.NAME))
    name = parseName(lexer)
  end
  pVD=parseVariableDefinitions(lexer)
  pD=parseDirectives(lexer)
  pS=parseSelectionSet(lexer)
  return OperationDefinition(operation,name,pVD,pD,pS)
end



"""
  SelectionSet : { Selection+ }
"""
function parseSelectionSet(lexer::Lexer)
  start_token= lexer.token()
  return SelectionSet(many(lexer, Tokens.LBRACE, parseSelection,Tokens.RBRACE#=,loc(lexer, start_token)=#))
end

"""
  Selection :
    - Field
    - FragmentSpread
    - InlineFragment
"""
function parseSelection(lexer::Lexer)
  return peek(lexer, Tokens.SPREAD) ? parseFragment(lexer) : parseField(lexer)
end

"""
  Field : Alias? Name Arguments? Directives? SelectionSet?

  Alias : Name : NAME
"""
function parseField(lexer::Lexer)
  start_token = lexer.token()

  nameOrAlias = parseName(lexer)
  alias=""
  name=""
  if (next_token(lexer, Tokens.COLON))
    alias = nameOrAlias
    name = parseName(lexer)
  else
    alias = nothing
    name = nameOrAlias
  end
  pA= parseArguments(lexer)
  pD= parseDirectives(lexer)
  pSS=(peek(lexer, Tokens.LBRACE) ? parseSelectionSet(lexer) : nothing)
  return Field(alias,name,pA,pD,pSS#=,loc(lexer, start_token) =#)
end



"""
  Converts a name lex token into a name parse node.
"""
function parseName(lexer::Lexer)
  token = expect(lexer, Tokens.NAME)
  return Name(token.val#=,loc(lexer, token)=#)
end

"""
 Arguments : ( Argument+ )
"""
function parseArguments(lexer::Lexer)
  return peek(lexer, Tokens.LPAREN) ? many(lexer, Tokens.LPAREN, parseArgument, Tokens.RPAREN) : []
end

"""
  Argument : Name : Value
"""
function parseArgument(lexer::Lexer)
  start_token = lexer.token()
  pN=parseName(lexer)
  return Argument(pN,(expect(lexer, Tokens.COLON).val, parseValueLiteral(lexer, false))#=,loc(lexer, start_token)=#)
end


"""
  Given a string containing a GraphQL value (ex. `[42]`), parse the AST for
  that value.
  Throws Diana.GraphQLError if a syntax error is encountered.

  This is useful within tools that operate upon GraphQL Values directly and
  in isolation of complete GraphQL documents.

  Consider providing the results to the utility function: valueFromAST().
"""
function parseValue(source::String)   ##export
  lexer = Lexer(source)
  value = parseValueLiteral(lexer, false)
  expect(lexer, Tokens.ENDMARKER)
  return value
end

"""
  Given a string containing a GraphQL Type (ex. `[Int!]`), parse the AST for
  that type.
  Throws Diana.GraphQLError if a syntax error is encountered.

  This is useful within tools that operate upon GraphQL Types directly and
  in isolation of complete GraphQL documents.

  Consider providing the results to the utility function: typeFromAST().
"""
function parseType(source::String) ##export
  sourceObj = source
  lexer = createLexer(sourceObj)
  tipe = parseTypeReference(lexer)
  expect(lexer, Tokens.ENDMARKER)
  return tipe
end


"""
 Implements the parsing rules in the Document section.

  OperationType : one of query mutation subscription
"""
function parseOperationType(lexer::Lexer)
	operationToken = expect(lexer, Tokens.NAME)
	if(operationToken.val =="query")
		return "query"
	end
	if(operationToken.val =="mutation")
		return "mutation"
	end
	# Note: subscription is an experimental non-spec addition.
	if(operationToken.val =="subscription")
		return "subscription"
	end

	return throw(ErrorException(unexpected(operationToken)))
end

"""
  VariableDefinitions : ( VariableDefinition+ )
"""
function parseVariableDefinitions(lexer::Lexer)
  return peek(lexer, Tokens.LPAREN) ? many(lexer,Tokens.LPAREN, parseVariableDefinition,Tokens.RPAREN) : []
end

"""
  VariableDefinition : Variable : Type DefaultValue?
"""
function parseVariableDefinition(lexer::Lexer)
  start_token = lexer.token()
  return VariableDefinition(parseVariable(lexer),((expect(lexer, Tokens.COLON)).val, parseTypeReference(lexer)),next_token(lexer, Tokens.EQUALS) ? parseValueLiteral(lexer, true) : nothing#=,loc(lexer, start_token)=#)
end

"""
  Variable : \$ Name
"""
function parseVariable(lexer::Lexer)
  start_token = lexer.token()
  expect(lexer, Tokens.DOLLAR)
  return Variable(parseName(lexer)#=,loc(lexer, start_token)=#)
end


"""
Implements the parsing rules in the Fragments section.

  Corresponds to both FragmentSpread and InlineFragment in the spec.

  FragmentSpread : ... FragmentName Directives?

  InlineFragment : ... TypeCondition? Directives? SelectionSet
"""
function parseFragment(lexer::Lexer)
  start_token = lexer.token()
  expect(lexer, Tokens.SPREAD)
  if (peek(lexer, Tokens.NAME) && lexer.token().val !== "on")
  	return FragmentSpread(parseFragmentName(lexer),parseDirectives(lexer)#=,loc(lexer, start_token)=#)
  end

  typeCondition = nothing

  if (lexer.token().val == "on")
    lexer.advance()
    typeCondition = parseNamedType(lexer)
  end
  pD=parseDirectives(lexer)
  pS=parseSelectionSet(lexer)
  return InlineFragment(typeCondition,pD,pS#=,loc(lexer, start_token)=#)
end

"""
  FragmentDefinition :
    - fragment FragmentName on TypeCondition Directives? SelectionSet

  TypeCondition : NamedType
"""
function parseFragmentDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer,"fragment")
  pFN= parseFragmentName(lexer)
  v=((expectKeyword(lexer,"on").val), parseNamedType(lexer))
  pD=parseDirectives(lexer)
  pS=parseSelectionSet(lexer)
  return FragmentDefinition(pFN,v,pD,pS#=,loc(lexer, start_token)=#)
end

"""
  FragmentName : Name but not `on`
"""
function parseFragmentName(lexer::Lexer)
  if (lexer.token().val == "on")
    return throw(ErrorException(unexpected(lexer)))
  end
  return parseName(lexer)
end

"""
Implements the parsing rules in the Values section.

  Value[Const] :
    - [~Const] Variable
    - IntValue
    - FloatValue
    - StringValue
    - BooleanValue
    - NullValue
    - EnumValue
    - ListValue[?Const]
    - ObjectValue[?Const]

  BooleanValue : one of `true` `false`

  NullValue : `null`

  EnumValue : Name but not `true`, `false` or `null`
"""
function parseValueLiteral(lexer::Lexer, isConst::Bool)
  token = lexer.token()
    if(token.kind==Tokens.LSQUARE)
      return parseList(lexer, isConst)
    end

    if(token.kind==Tokens.LBRACE)
      return parseObject(lexer, isConst)
    end

    if(token.kind==Tokens.INT)
      lexer.advance()
      return IntValue(token.val#=,loc(lexer, token)=#)
    end

    if(token.kind==Tokens.FLOAT)
      lexer.advance()
      return FloatValue(token.val#=,loc(lexer, token)=#)
    end

    if(token.kind==Tokens.STRING)
      lexer.advance()
      return StringValue(token.val#=,loc(lexer, token)=#)
    end

    if(token.kind==Tokens.NAME)
      if(token.val == "true" || token.val == "false")
        lexer.advance()
        return BooleanValue(token.val == "true"#=,loc(lexer, token)=#)
      elseif(token.val == "null")
        lexer.advance()
        return NullValue(#=loc(lexer, token)=#)
      end

      lexer.advance()
      return EnumValue(token.val#=,loc(lexer, token)=#)
    end

    if(token.kind==Tokens.DOLLAR)
      if (!isConst)
        return parseVariable(lexer)
      end
      #break
    end

  return throw(ErrorException(unexpected(lexer)))
end

function parseConstValue(lexer::Lexer) ##export
  return parseValueLiteral(lexer, true)
end

function parseValueValue(lexer::Lexer)
  return parseValueLiteral(lexer, false)
end

"""
  ListValue[Const] :
    - [ ]
    - [ Value[?Const]+ ]
"""
function parseList(lexer::Lexer, isConst::Bool)
  start_token = lexer.token()
  item = isConst ? parseConstValue : parseValueValue
  return List_(an_y(lexer, Tokens.LSQUARE, item, Tokens.RSQUARE)#=,loc(lexer, start_token)=#)
end

"""
  ObjectValue[Const] :
    - { }
    - { ObjectField[?Const]+ }
"""
function parseObject(lexer::Lexer, isConst::Bool)
  start_token = lexer.token()
  expect(lexer, Tokens.LBRACE)
  fields = []
  while (!next_token(lexer, Tokens.RBRACE))
    push!(fields,parseObjectField(lexer, isConst))
  end
  return Object_(fields#=,loc(lexer, start_token)=#)
end

"""
  ObjectField[Const] : Name : Value[?Const]
"""
function parseObjectField(lexer::Lexer, isConst::Bool)
  start_token = lexer.token()
  return Object_Field(parseName(lexer),((expect(lexer, Tokens.COLON)).val, parseValueLiteral(lexer, isConst))#=,loc(lexer, start_token)=#)
end

"""
Implements the parsing rules in the Directives section.

  Directives : Directive+
"""
function parseDirectives(lexer::Lexer)
  directives = []
  while (peek(lexer,Tokens.AT))
    push!(directives,parseDirective(lexer))
  end
  return directives
end

"""
  Directive : @ Name Arguments?
"""
function parseDirective(lexer::Lexer)
  start_token = lexer.token()
  expect(lexer, Tokens.AT)
  return Directive(parseName(lexer),parseArguments(lexer)#=,loc(lexer, start_token)=#)
end

"""
Implements the parsing rules in the Types section.

  Type :
    - NamedType
    - ListType
    - NonNullType
"""
function parseTypeReference(lexer::Lexer) ##export
  start_token = lexer.token()
  tipe=""
  if(next_token(lexer, Tokens.LSQUARE))
    tipe = parseTypeReference(lexer)
    expect(lexer, Tokens.RSQUARE)
    tipe = ListType(tipe#=,loc(lexer, start_token)=#)
  else
    tipe = parseNamedType(lexer)
  end
  if (next_token(lexer, Tokens.BANG))
  	return NonNullType(tipe#=,loc(lexer, start_token)=#)
  end
  return tipe
end

"""
  NamedType : Name
"""
function parseNamedType(lexer::Lexer)  ##export
  start_token = lexer.token()
  return NamedType(parseName(lexer)#=,loc(lexer, start_token)=#)
end


"""
Implements the parsing rules in the Type Definition section.

  TypeSystemDefinition :
    - SchemaDefinition
    - TypeDefinition
    - TypeExtensionDefinition
    - DirectiveDefinition

  TypeDefinition :
    - ScalarTypeDefinition
    - ObjectTypeDefinition
    - InterfaceTypeDefinition
    - UnionTypeDefinition
    - EnumTypeDefinition
    - InputObjectTypeDefinition
"""
function parseTypeSystemDefinition(lexer::Lexer)
  if (peek(lexer, Tokens.NAME))
      if(lexer.token().val=="schema") return parseSchemaDefinition(lexer) end
      if(lexer.token().val=="scalar") return parseScalarTypeDefinition(lexer) end
      if(lexer.token().val=="type") return parseObjectTypeDefinition(lexer) end
      if(lexer.token().val=="interface") return parseInterfaceTypeDefinition(lexer) end
      if(lexer.token().val=="union") return parseUnionTypeDefinition(lexer) end
      if(lexer.token().val=="enum") return parseEnumTypeDefinition(lexer) end
      if(lexer.token().val=="input") return parseInputObjectTypeDefinition(lexer) end
      if(lexer.token().val=="extend") return parseTypeExtensionDefinition(lexer) end
      if(lexer.token().val=="directive") return parseDirectiveDefinition(lexer) end
  end

  return throw(ErrorException(unexpected(lexer)))
end

"""
  SchemaDefinition : schema Directives? { OperationTypeDefinition+ }

  OperationTypeDefinition : OperationType : NamedType
"""
function parseSchemaDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer,"schema")
  directives = parseDirectives(lexer)
  operationTypes = many(lexer,Tokens.LBRACE,parseOperationTypeDefinition,Tokens.RBRACE)
  return SchemaDefinition(directives,operationTypes#=,loc(lexer, start_token)=#)
end

function parseOperationTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  operation = parseOperationType(lexer)
  expect(lexer, Tokens.COLON)
  tipe = parseNamedType(lexer)
  return OperationTypeDefinition(operation,tipe#=,loc(lexer, start_token)=#)
end

"""
  ScalarTypeDefinition : scalar Name Directives?
"""
function parseScalarTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer,"scalar")
  name = parseName(lexer)
  directives = parseDirectives(lexer)
  return ScalarTypeDefinition(name,directives#=,loc(lexer, start_token)=#)
end

"""
  ObjectTypeDefinition :
    - type Name ImplementsInterfaces? Directives? { FieldDefinition+ }
"""
function parseObjectTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer, "type")
  name = parseName(lexer)
  interfaces = parseImplementsInterfaces(lexer)
  directives = parseDirectives(lexer)
  fields = an_y(lexer,Tokens.LBRACE,parseFieldDefinition,Tokens.RBRACE)
  return ObjectTypeDefinition(name,interfaces,directives,fields#=,loc(lexer, start_token)=#)
end

"""
  ImplementsInterfaces : implements NamedType+
"""
function parseImplementsInterfaces(lexer::Lexer)
  tipes = []

  try
  expectKeyword(lexer,"implements")
    while true
    	push!(tipes,parseNamedType(lexer))
        if(!peek(lexer, Tokens.NAME))
        	break
        end
    end
  return tipes
  catch
    return []
  end
end

"""
  FieldDefinition : Name ArgumentsDefinition? : Type Directives?
"""
function parseFieldDefinition(lexer::Lexer)
  start_token = lexer.token()
  name = parseName(lexer)
  args = parseArgumentDefs(lexer)
  expect(lexer, Tokens.COLON)
  tipe = parseTypeReference(lexer)
  directives = parseDirectives(lexer)
  return FieldDefinition(name,args,tipe,directives#=,loc(lexer, start_token)=#)
end

"""
  ArgumentsDefinition : ( InputValueDefinition+ )
"""
function parseArgumentDefs(lexer::Lexer)
  if (!peek(lexer, Tokens.LPAREN))
    return []
  end
  return many(lexer, Tokens.LPAREN, parseInputValueDef, Tokens.RPAREN)
end

"""
  InputValueDefinition : Name : Type DefaultValue? Directives?
"""
function parseInputValueDef(lexer::Lexer)
  start_token = lexer.token()
  name = parseName(lexer)
  expect(lexer, Tokens.COLON)
  tipe = parseTypeReference(lexer)
  defaultValue = nothing
  if(next_token(lexer, Tokens.EQUALS))
    defaultValue = parseConstValue(lexer)
  end
  directives = parseDirectives(lexer)
  return InputValueDefinition(name,tipe,defaultValue,directives#=,loc(lexer, start_token)=#)
end

"""
  InterfaceTypeDefinition : interface Name Directives? { FieldDefinition+ }
"""
function parseInterfaceTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer,"interface")
  name = parseName(lexer)
  directives = parseDirectives(lexer)
  fields = an_y(lexer,Tokens.LBRACE,parseFieldDefinition,Tokens.RBRACE)

  return InterfaceTypeDefinition(name,directives,fields#=,loc(lexer, start_token)=#)
end

"""
  UnionTypeDefinition : union Name Directives? = UnionMembers
"""
function parseUnionTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer, "union")
  name = parseName(lexer)
  directives = parseDirectives(lexer)
  expect(lexer, Tokens.EQUALS)
  tipes = parseUnionMembers(lexer)
  return UnionTypeDefinition(name,directives,tipes,#=loc(lexer, start_token)=#)
end


"""
	UnionMembers :
    - `|`? NamedType
    - UnionMembers | NamedType
"""
function parseUnionMembers(lexer::Lexer)
  # Optional leading pipe
  next_token(lexer, Tokens.PIPE)
  members = []
  while true
  	push!(members,parseNamedType(lexer))
  	if(!next_token(lexer, Tokens.PIPE))
  	    break
  	end
  end

  return members
end

"""
  EnumTypeDefinition : enum Name Directives? { EnumValueDefinition+ }
"""
function parseEnumTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer, "enum")
  name = parseName(lexer)
  directives = parseDirectives(lexer)
  _values = many(lexer,Tokens.LBRACE,parseEnumValueDefinition,Tokens.RBRACE)
  return EnumTypeDefinition(name,directives,_values,#=loc(lexer, start_token),=#)
end

"""
  EnumValueDefinition : EnumValue Directives?

  EnumValue : Name
"""
function parseEnumValueDefinition(lexer::Lexer)
  start_token = lexer.token()
  name = parseName(lexer)
  directives = parseDirectives(lexer)
  return EnumValueDefinition(name,directives#=,loc(lexer, start_token),=#)
end

"""
  InputObjectTypeDefinition : input Name Directives? { InputValueDefinition+ }
"""
function parseInputObjectTypeDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer, "input")
  name = parseName(lexer)
  directives = parseDirectives(lexer)
  fields = an_y(lexer,Tokens.LBRACE,parseInputValueDef,Tokens.RBRACE)
  return InputObjectTypeDefinition(name,directives,fields#=,loc(lexer, start_token)=#)
end

"""
  TypeExtensionDefinition : extend ObjectTypeDefinition
"""
function parseTypeExtensionDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer, "extend")
  definition = parseObjectTypeDefinition(lexer)
  TypeExtensionDefinition
  return TypeExtensionDefinition(definition#=,loc(lexer, start_token)=#)
end

"""
  DirectiveDefinition :
    - directive @ Name ArgumentsDefinition? on DirectiveLocations
"""
function parseDirectiveDefinition(lexer::Lexer)
  start_token = lexer.token()
  expectKeyword(lexer, "directive")
  expect(lexer, Tokens.AT)
  name = parseName(lexer)
  args = parseArgumentDefs(lexer)
  expectKeyword(lexer, "on")
  locations = parseDirectiveLocations(lexer)
  return DirectiveDefinition(name,args,locations#=,loc(lexer, start_token)=#)
end

"""
  DirectiveLocations :
    - `|`? Name
    - DirectiveLocations | Name
"""
function parseDirectiveLocations(lexer::Lexer)
  # Optional leading pipe
  next_token(lexer, Tokens.PIPE)
  locations = []
  while true
  	push!(locations,parseName(lexer))
    if(!next_token(lexer, Tokens.PIPE))
      break
    end
  end
  return locations
end

function Base.show(io::IO, x::Node)
  t = typeof(x)
  print(io, "\n\e[33m < \e[37m")
    for f in fieldnames(t)
      elemento = getfield(x, f)
      v= true
      try
        v = length(elemento)>0
      catch
        v=true
      end
      if (elemento!=nothing && v)
        if(f == :kind)
          print(io,"Node :: ",elemento)
        elseif(f == :value) || (f == :operation)
          print(io," ,",f ," : \e[92m",elemento,"\e[37m")
        else
          print(io," ,",f ," : ",elemento)
        end
      end
    end

  print(io,"\e[33m > \e[37m")
end
