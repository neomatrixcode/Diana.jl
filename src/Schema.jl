

mutable struct schema
  execute::Function
end



function Schema(_schema)

my_schema = _schema

    function execute(query::String)
      ast=""
      try
         ast= Parse(query)
     catch e
        s=string(e.msg)
        println(s)
        m=match(r"(?<text>^.*)in:[\s]*[\w]+[\s]*(?<line>\d+)[\s]*,[\s]*col[\s]*(?<col>\d+)",s)
        return "{\"errors\":[{\"locations\": [{\"column\": $(m["col"]),\"line\": $(m["line"])}],\"message\": \"Syntax Error GraphQL request ($(m["col"]):$(m["line"])) $(m["text"])\"}]}"
      end
    end

 return schema(execute)

end