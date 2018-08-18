query = """
       {
         neomatrix{
             nombre
                 linkedin
                   }
                   }
               """
r = Queryclient(query,true)
@test r == "ok"

query = """
{
  neomatrix{
    nombre
    linkedin
  }
}
"""

r = Queryclient("https://neomatrix.herokuapp.com/graphql",query,headers=Dict("header"=>"value"))

@test r.Info.status == 200
@test r.Data == "{\"data\":{\"neomatrix\":{\"nombre\":\"Acevedo Maldonado Josue\",\"linkedin\":\"https://www.linkedin.com/in/acevedo-maldonado-josue/\"}}}"


client = GraphQLClient("https://api.graph.cool/simple/v1/movies",auth="Bearer my-jwt-token",headers=Dict("header"=>"value"))

query2 = """
query getMovie(\$title: String!) {
  Movie(title:\$title) {
    releaseDate
    actors {
      name
    }
  }
}
"""
r = client.Query(query2,vars=Dict("title" => "Inception"))

@test r.Info.status == 200
@test r.Data == "{\"data\":{\"Movie\":{\"releaseDate\":\"2010-08-28T20:00:00.000Z\",\"actors\":[{\"name\":\"Leonardo DiCaprio\"},{\"name\":\"Ellen Page\"},{\"name\":\"Tom Hardy\"},{\"name\":\"Joseph Gordon-Levitt\"},{\"name\":\"Marion Cotillard\"}]}}}"


r = client.Query(query2,check=true)
@test r == "ok"

query2 = """
{
  Movie(title: "Inception"){
    actors{
      name
    }
  }
}
"""
r = client.Query(query2)

@test r.Info.status == 200
@test r.Data == "{\"data\":{\"Movie\":{\"actors\":[{\"name\":\"Leonardo DiCaprio\"},{\"name\":\"Ellen Page\"},{\"name\":\"Tom Hardy\"},{\"name\":\"Joseph Gordon-Levitt\"},{\"name\":\"Marion Cotillard\"}]}}}"

r = client.Query(query2,getlink=true)

@test r == "https://api.graph.cool/simple/v1/movies?query=%7B%0A%20%20Movie%28title%3A%20%22Inception%22%29%7B%0A%20%20%20%20actors%7B%0A%20%20%20%20%20%20name%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A"

@test client.headers(Dict("header"=>"value")) == Dict("header"=>"value")

@test client.serverAuth("Bearer my-jwt-token") == "Bearer my-jwt-token"



query="https://neomatrix.herokuapp.com/graphql?query=%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%20%20linkedin%0A%20%20%7D%0A%7D"
r = Queryclient(query)
@test r.Info.status == 200
@test r.Data == "{\"data\":{\"neomatrix\":{\"nombre\":\"Acevedo Maldonado Josue\",\"linkedin\":\"https://www.linkedin.com/in/acevedo-maldonado-josue/\"}}}"


query = """
{
  neomatrix{
    nombre
    linkedin
  }
}
"""

r = Queryclient("https://neomatrix.herokuapp.com/graphql",query,getlink=true)
@test r == "https://neomatrix.herokuapp.com/graphql?query=%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%20%20linkedin%0A%20%20%7D%0A%7D%0A"


query = """
       query consulta{
          neomatrix{
            nombre
            linkedin
          }
        }

       query hola{
          neomatrix{
            nombre
          }
       }
       """
r = Queryclient("https://neomatrix.herokuapp.com/graphql",query,operationName="hola")
@test r.Data == "{\"data\":{\"neomatrix\":{\"nombre\":\"Acevedo Maldonado Josue\"}}}"

query = """
query consulta{
  Movie(title: "Inception"){
    actors{
      name
    }
  }
}
query hola{
  Movie(title: "Inception"){
    actors{
      name
    }
  }
}
"""
r = client.Query(query,operationName="consulta")

@test r.Data == "{\"data\":{\"Movie\":{\"actors\":[{\"name\":\"Leonardo DiCaprio\"},{\"name\":\"Ellen Page\"},{\"name\":\"Tom Hardy\"},{\"name\":\"Joseph Gordon-Levitt\"},{\"name\":\"Marion Cotillard\"}]}}}"

query = """
query consulta{
  neomatrix{
    nombre
  }
}
query hola{
  neomatrix{
    nombre
    linkedin
  }
}
"""
r = Queryclient("https://neomatrix.herokuapp.com/graphql",query,getlink=true,operationName="consulta")

@test r == "https://neomatrix.herokuapp.com/graphql?query=query%20consulta%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%7D%0A%7D%0Aquery%20hola%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%20%20linkedin%0A%20%20%7D%0A%7D%0A&operationName=consulta"