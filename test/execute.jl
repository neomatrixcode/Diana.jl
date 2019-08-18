
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
    @test string(e.msg) ==  "{\"data\": null,\"errors\": [{\"message\": \"The jajaaj field does not exists.\"}]}"
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


 my_schema = Schema("prueba.graphql", resolvers)


query= """
query{
  neomatrix{
    nombre
  }
}
"""


@test my_schema.execute(query) == "{\"data\":{\"neomatrix\":{\"nombre\":\"josue\"}}}"




query= """
query prueba1{
  neomatrix{
    nombre
  }
}

query prueba2{
  neomatrix{
    edad
  }
}
"""


@test my_schema.execute(query, operationName="prueba1") == "{\"data\":{\"neomatrix\":{\"nombre\":\"josue\"}}}"



query= """
query prueba1{
  neomatrix{
    nombre
  }
}

query prueba2{
  neomatrix{
    edad
  }
}
"""


@test my_schema.execute(query, operationName="prueba2") == "{\"data\":{\"neomatrix\":{\"edad\":25}}}"

#---------------------------------------------------------------------------------------------------------

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

,"mutation" => "Mutation"
,"Mutation" => Dict(

    "addPerson"=>Dict(

      "args"=>Dict(
        "nombre"=>"String",
        "edad"=>"Int")

      ,"tipo"=>"Persona"

      )

  )
)

#root : resultado del tipo anterior / principal
#args : argumentos proporcionados al campo
#contexto : unobjeto mutable que se proporciona a todos los resolvers (pasar datos entre resolvers)
#informacion : Información específica del campo relevante para la consulta (rara vez se usa)

 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
          return Dict("nombre"=>"josue","edad"=>25,"altura"=>10.5,"spooilers"=>false)
          )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14,"altura"=>11.8,"spooilers"=>true))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
    ,"Mutation"=>Dict(
        "addPerson" => (root,args,ctx,info)->(
          return Dict("nombre"=>args["nombre"],"edad"=>args["edad"],"altura"=>10.5,"spooilers"=>false)
          )
    )
)


 my_schema = Schema(schema, resolvers)

query= """

mutation {
  addPerson(nombre: "bob", edad: 20){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"



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
type Mutation{
  addPerson(nombre:String,edad:Int): Persona
}
 schema {
  query: Query
  mutation:Mutation
}
 """


#root : resultado del tipo anterior / principal
#args : argumentos proporcionados al campo
#contexto : unobjeto mutable que se proporciona a todos los resolvers (pasar datos entre resolvers)
#informacion : Información específica del campo relevante para la consulta (rara vez se usa)

 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
          return Dict("nombre"=>"josue","edad"=>25,"altura"=>10.5,"spooilers"=>false)
          )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14,"altura"=>11.8,"spooilers"=>true))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
    ,"Mutation"=>Dict(
        "addPerson" => (root,args,ctx,info)->(
          return Dict("nombre"=>args["nombre"],"edad"=>args["edad"],"altura"=>10.5,"spooilers"=>false)
          )
    )
)


 my_schema = Schema(schema, resolvers)



query= """
mutation {
  addPerson(nombre: "bob", edad: 20){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"


query= """

mutation mutationwithvariarbles(\$miedad: Int){
  addPerson(nombre: "bob", edad: \$miedad){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query,Variables=Dict("miedad"=>20)) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"


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
,"DataInputType" => Dict(
    "edad"=>Dict("tipo"=>"Int")
    ,"nombre"=>Dict("tipo"=>"String")
  )
,"mutation" => "Mutation"
,"Mutation" => Dict(

    "addPerson"=>Dict(

      "args"=>Dict(
        "data"=>"DataInputType")

      ,"tipo"=>"Persona"

      )

  )
)

#root : resultado del tipo anterior / principal
#args : argumentos proporcionados al campo
#contexto : unobjeto mutable que se proporciona a todos los resolvers (pasar datos entre resolvers)
#informacion : Información específica del campo relevante para la consulta (rara vez se usa)

 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
          return Dict("nombre"=>"josue","edad"=>25)
          )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
    ,"Mutation"=>Dict(
        "addPerson" => (root,args,ctx,info)->(
          return Dict("nombre"=>args["data"]["nombre"],"edad"=>args["data"]["edad"])
          )
    )
)


 my_schema = Schema(schema, resolvers)



query= """

mutation {
  addPerson(data: {nombre: "bob", edad: 20}){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"




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
,"DataInputType" => Dict(
    "edad"=>Dict("tipo"=>"Int")
    ,"nombre"=>Dict("tipo"=>"String")
  )
,"mutation" => "Mutation"
,"Mutation" => Dict(

    "addPerson"=>Dict(

      "args"=>Dict(
        "data"=>"DataInputType")

      ,"tipo"=>"Persona"

      )

  )
)

 schema= """
type Persona {
  nombre: String
  edad: Int
}
 type Query{
  persona: Persona
  neomatrix: Persona
}
input DataInputType{
  nombre: String
  edad: Int
}
type Mutation{
  addPerson(data:DataInputType): Persona
}
 schema {
  query: Query
  mutation:Mutation
}
 """

#root : resultado del tipo anterior / principal
#args : argumentos proporcionados al campo
#contexto : unobjeto mutable que se proporciona a todos los resolvers (pasar datos entre resolvers)
#informacion : Información específica del campo relevante para la consulta (rara vez se usa)

 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
          return Dict("nombre"=>"josue","edad"=>25)
          )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
    ,"Mutation"=>Dict(
        "addPerson" => (root,args,ctx,info)->(
          return Dict("nombre"=>args["data"]["nombre"],"edad"=>args["data"]["edad"])
          )
    )
)


 my_schema = Schema(schema, resolvers)



query= """

mutation {
  addPerson(data: {nombre: "bob", edad: 20}){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"

 schema= """
type Persona {
  nombre: String
  edad: Int
}
 type Query{
  persona: Persona
  neomatrix: Persona
}
input DataInputType{
  nombre: String
  edad: Int
}
type Mutation{
  addPerson(data:DataInputType): Persona
}
 schema {
  query: Query
  mutation:Mutation
}
 """


 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
          return Dict("nombre"=>"josue","edad"=>25)
          )
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>14))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
    ,"Mutation"=>Dict(
        "addPerson" => (root,args,ctx,info)->begin

          println(ctx["data"])
          return Dict("nombre"=>args["data"]["nombre"],"edad"=>args["data"]["edad"])
          end
    )
)


 my_schema = Schema(schema, resolvers, context=Dict("data"=>"datacontext"))



 query= """

mutation {
  addPerson(data: {nombre: "bob", edad: 20}){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"




 query= """

mutation mutationwithvariarbles(\$dato: DataInputType){
  addPerson(data: \$dato ){
    nombre,
    edad
  }
}
"""

@test my_schema.execute(query,Variables=Dict("dato"=>Dict("edad"=>20,"nombre"=>"bob"))) == "{\"data\":{\"addPerson\":{\"edad\":20,\"nombre\":\"bob\"}}}"
