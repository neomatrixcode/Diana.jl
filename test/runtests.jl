using Diana
using Base.Test


query = """
{
  neomatrix{
    nombre
    linkedin
  }
} 
"""   


@test Query("https://neomatrix.herokuapp.com/graphql",query) == "{\"data\":{\"neomatrix\":{\"nombre\":\"Acevedo Maldonado Josue\",\"linkedin\":\"https://www.linkedin.com/in/acevedo-maldonado-josue/\"}}}"

client = GraphQLClient("https://api.graph.cool/simple/v1/movies","Bearer my-jwt-token")

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

@test client.Query(query2,vars=Dict("title" => "Inception")) == "{\"data\":{\"Movie\":{\"releaseDate\":\"2010-08-28T20:00:00.000Z\",\"actors\":[{\"name\":\"Leonardo DiCaprio\"},{\"name\":\"Ellen Page\"},{\"name\":\"Tom Hardy\"},{\"name\":\"Joseph Gordon-Levitt\"},{\"name\":\"Marion Cotillard\"}]}}}"

query2 = """
{
  Movie(title: "Inception"){
    actors{
      name
    }
  }
}
""" 

@test client.Query(query2) == "{\"data\":{\"Movie\":{\"actors\":[{\"name\":\"Leonardo DiCaprio\"},{\"name\":\"Ellen Page\"},{\"name\":\"Tom Hardy\"},{\"name\":\"Joseph Gordon-Levitt\"},{\"name\":\"Marion Cotillard\"}]}}}"