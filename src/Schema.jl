

type schema
  execute::Function
end



function Schema(_schema)

my_schema = _schema
	
    function execute(query::String)
      ast=""
      try                           
         ast= Parse(str)
     catch e                       
        s=string(e.msg) 
        m=match(r"(?<line>\d+)[\s]*,?[\s]*(\w)+[\s]*(?<col>\d+)",s)              
        return "{\"errors\": [{\"message\": \"Syntax Error GraphQL request $s\",\"locations\": [{\"column\": $(m["col"]),\"line\": $(m["line"])}]}]}"
      end
    end

 return schema(execute) 

end