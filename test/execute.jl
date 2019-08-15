
 schema= """
type Persona {
  nombre: String
  edad: Int
  altura: Float
  spooilers:Boolean
}
 type Query{
  persona: Persona
  neomatrix: Persona
}
 schema {
  query: Query
}
 """


#root : resultado del tipo anterior / principal
#args : argumentos proporcionados al campo
#contexto : unobjeto mutable que se proporciona a todos los resolvers (pasar datos entre resolvers)
#informacion : Información específica del campo relevante para la consulta (rara vez se usa)

 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(return Dict("nombre"=>"josue","edad"=>25,"altura"=>10.5,"spooilers"=>false) )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14,"altura"=>11.8,"spooilers"=>true))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
)


 my_schema = Schema(schema, resolvers)


query= """
query{
  neomatrix{
  	nombre
  }
}
"""


@test my_schema.execute(query) == "{\"data\":{\"neomatrix\":{\"nombre\":\"josue\"}}}"



query= """
        query{
          neomatrix{
               nombre
                 }
          neomatrix{
          edad
          }
          }"""


@test my_schema.execute(query) == "{\"data\":{\"neomatrix\":{\"edad\":25,\"nombre\":\"josue\"}}}"




query= """
        query{
          neomatrix{
               nombre
               altura
                 }
          persona{
          nombre
          edad
          spooilers
          }
          }"""


@test my_schema.execute(query) == "{\"data\":{\"persona\":{\"edad\":14,\"spooilers\":true,\"nombre\":\"Diana\"},\"neomatrix\":{\"altura\":10.5,\"nombre\":\"josue\"}}}"

query= """
        query{
          neomatrix{
               nombre
               altura
               jajaaj
                 }
          persona{
          nombre
          edad
          spooilers
          }
          }"""

try
my_schema.execute(query)
catch e
  if e isa Diana.GraphQLError
    @test string(e.msg) == "{\"data\": null,\"errors\": [{\"message\": \"Field jajaaj not exists.\"}]}"
  end
end



schema = Dict(
"query" => "Query"
,"Query"   => Dict(
    "persona"=>Dict("tipo"=>"Persona")
     ,"neomatrix"=>Dict("tipo"=>"Persona")
   )
,"Persona" => Dict(
    "edad"=>Dict("tipo"=>"Int")
    ,"nombre"=>Dict("tipo"=>"String")
  )
)


 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(return Dict("nombre"=>"josue","edad"=>25) )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
)


 my_schema = Schema(schema, resolvers)


query= """
{
  neomatrix{
  	nombre
  }
}
"""


@test my_schema.execute(query) == "{\"data\":{\"neomatrix\":{\"nombre\":\"josue\"}}}"