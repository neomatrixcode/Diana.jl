
function parser(str)

	table=collect(tokenize(str))
	errors= filter(x -> (x.kind == Tokens.ERROR), table)
	if length(errors)>0
		println("Syntax Error GraphQL request (x:x) Unexpected character")
		errors
		# {"errors":[{"locations":[{"column":5,"line":3}],"message":"Syntax Error GraphQL request (3:5) Unexpected character \"*\".\n\n2:   neomatrix{\n3:     *nombre\n       ^\n4:     linkedin\n"}]}
	else
		filter!(x -> (Tokens.ENDMARKER != x.kind != Tokens.WHITESPACE), table)
	end
	

end