
# Client

## Simple query

```julia
using Diana

query = """
        {
          neomatrix{
            nombre
            linkedin
          }
        }
        """

r = Queryclient("https://neomatrix.herokuapp.com/graphql",
                query,
                headers = Dict("header" => "value"))
r.Info.status == 200 && println(r.Data)
```
result:
```julia
{
  "data":{
    "neomatrix":{
        "nombre":"Acevedo Maldonado Josue",
        "linkedin":"https://www.linkedin.com/in/acevedo-maldonado-josue/"
    }
  }
}
```
```julia
query = """
        query consulta {
          neomatrix {
            nombre
            linkedin
          }
        }

        query hola {
          neomatrix {
            nombre
          }
        }
        """
r = Queryclient("https://neomatrix.herokuapp.com/graphql",query,operationName="hola")
r.Info.status == 200 && println(r.Data)
```
result:
```
{"data":{"neomatrix":{"nombre":"Acevedo Maldonado Josue"}}}
```

```julia
using Diana
github_endpoint = "https://api.github.com/graphql"
github_user = # GitHub handle
github_token = # GitHub personal token
github_header = Dict("User-Agent" => github_user)
client = GraphQLClient(github_endpoint,
                       auth = "bearer $github_token",
                       headers = github_header)
query = """
        query A{
          rateLimit {
            cost
            remaining
            resetAt
          }
          repository(owner: "JuliaLang", name: "Julia") {
            id
          }
        }"""

r = client.Query(query, operationName = "A")
r.Info.status == 200 && println(r.Data)
```

## Query

```julia
using Diana

client = GraphQLClient("https://api.graph.cool/simple/v1/movies")
client.serverAuth("Bearer my-jwt-token")
client.headers(Dict("header"=>"value"))

or

client = GraphQLClient("https://api.graph.cool/simple/v1/movies",auth="Bearer my-jwt-token",headers=Dict("header"=>"value"))
```

```julia
query = """
        {
          Movie(title: "Inception"){
            actors{
              name
            }
          }
        }
        """

r = client.Query(query)
r.Info.status == 200 && println(r.Data)
```
result:
```julia
{
  "data":{
    "Movie":{
      "actors":[
        {
          "name":"Leonardo DiCaprio"
        },
        {
          "name":"Ellen Page"
        },
        {
          "name":"Tom Hardy"
        },
        {
          "name":"Joseph Gordon-Levitt"
        },
        {
          "name":"Marion Cotillard"
        }
      ]
    }
  }
}
```

```julia
query = """
        query getMovie(\$title: String!) {
          Movie(title:\$title) {
            releaseDate
            actors {
              name
            }
          }
        }
        """
r = client.Query(query, vars= Dict("title" => "Inception"))

println(r.Data)
```

```julia
query = """
        query consulta {
          Movie(title: "Inception") {
            actors{
              name
            }
          }
        }
        query hola {
          Movie(title: "Inception") {
            actors{
              name
            }
          }
        }
        """
r = client.Query(query, operationName = "consulta")
r.Info.status == 200 && println(r.Data)
```
result:
```
{"data":{"Movie":{"actors":[{"name":"Leonardo DiCaprio"},{"name":"Ellen Page"},{"name":"Tom Hardy"},{"name":"Joseph Gordon-Levitt"},{"name":"Marion Cotillard"}]}}}
```
## Change serverUrl
```julia
client.serverUrl("https://api.graph.cool/simple/v1/movies")
```
## Change headers
```julia
client.headers(Dict("header" => "value"))
```
## Change serverAuth
```julia
client.serverAuth("Bearer my-jwt-token")
```

## Query get
```julia
query="https://neomatrix.herokuapp.com/graphql?query=%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%20%20linkedin%0A%20%20%7D%0A%7D"
r = Queryclient(query)
r.Info.status == 200 && println(r.Data)
```

## Link
It is possible to get links to the graphql query editor

```julia
query = """
        {
          neomatrix{
            nombre
            linkedin
          }
        }
        """
r = Queryclient("https://neomatrix.herokuapp.com/graphql",query,getlink=true)
```
result:
```
"https://neomatrix.herokuapp.com/graphql?query=%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%20%20linkedin%0A%20%20%7D%0A%7D%0A"
```
or
```julia
r = client.Query(query, getlink = true)
```
result:
```
"https://api.graph.cool/simple/v1/movies?query=%7B%0A%20%20Movie%28title%3A%20%22Inception%22%29%7B%0A%20%20%20%20actors%7B%0A%20%20%20%20%20%20name%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D%0A"
```
```julia
query = """
        query consulta {
          neomatrix {
            nombre
          }
        }
        query hola {
          neomatrix {
            nombre
            linkedin
          }
        }
        """
r = Queryclient("https://neomatrix.herokuapp.com/graphql",
                query,
                getlink = true,
                operationName = "consulta")
```
result:
```
"https://neomatrix.herokuapp.com/graphql?query=query%20consulta%7B%0A%20%20neomatrix%7B%0A%20%20%20%20%20%20nombre%0A%20%20%20%7D%0A%7D%0Aquery%20hola%7B%0A%20%20neomatrix%7B%0A%20%20%20%20%20%20nombre%0A%20%20%20%20%20%20linkedin%0A%20%20%20%20%7D%0A%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20&operationName=consulta"
```

## Validating query
It is possible to validate the query locally before sending the request, only basic validations are carried out.
```julia
query = """
        {
          neomatrix{
            nombre
            linkedin
          }
        }
        """
r = Queryclient(query, check = true)
```
result:
```
"ok"
```
```julia
 query = """
         {
         neomatrix {
           nombre
           linkedin
         }
         }
         """
r = Queryclient(query, true)
```
result:
```
ERROR: {"errors":[{"locations": [{"column": 3,"line": 2}],"message": "Syntax Error GraphQL request (3:2) Expected NAME, found } "}]}
```
```julia
r = client.Query(query, check = true)
```
