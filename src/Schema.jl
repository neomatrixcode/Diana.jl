

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
        return s
      end
    end

 return schema(execute)

end