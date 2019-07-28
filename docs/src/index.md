## About

This repository is an implementation of a GraphQL server, a query language for API created by Facebook.
See more complete documentation at http://graphql.org/

Looking for help? Find resources from the community.

### Getting Started
An overview of GraphQL in general is available in the [README](https://github.com/facebook/graphql/blob/master/README.md) for the Specification for GraphQL.

This package is intended to help you building GraphQL schemas/types fast and easily.
+ **Easy to use:** Diana.jl helps you use GraphQL in Julia without effort.
+ **Data agnostic:** Diana.jl supports any type of data source: SQL, NoSQL, etc. The intent is to provide a complete API and make your data available through GraphQL.
+ **Make queries:** Diana.jl allows queries to graphql schemas

Installing
----------
```julia
Pkg> add Diana
#Release
pkg> add Diana#master
#Development
```

Client
----------
### Simple query

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

### Query

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
### Change serverUrl
```julia
client.serverUrl("https://api.graph.cool/simple/v1/movies")
```
### Change headers
```julia
client.headers(Dict("header" => "value"))
```
### Change serverAuth
```julia
client.serverAuth("Bearer my-jwt-token")
```

### Query get
```julia
query="https://neomatrix.herokuapp.com/graphql?query=%7B%0A%20%20neomatrix%7B%0A%20%20%20%20nombre%0A%20%20%20%20linkedin%0A%20%20%7D%0A%7D"
r = Queryclient(query)
r.Info.status == 200 && println(r.Data)
```

### Link
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

### Validating query
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
         }
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

#### Note
The lexer is built based on the [Tokenize](https://github.com/KristofferC/Tokenize.jl) package code and the Parser on the [graphql-js](https://github.com/graphql/graphql-js) package

### Thanks people

Lexer
----------
```julia
using Diana

Tokensgraphql("""
              #
              query {
                Region(name: "The North") {
                  NobleHouse(name: "Stark") {
                    castle {
                      name
                    }
                    members {
                      name
                      alias
                    }
                  }
                }
              }
              """)
```
result:
```
29-element Array{Diana.Tokens.Token,1}:
 NAME           query               2,1 - 2,5
 LBRACE         {                   2,7 - 2,7
 NAME           Region              3,3 - 3,8
 LPAREN         (                   3,9 - 3,9
 NAME           name                3,10 - 3,13
 COLON          :                   3,14 - 3,14
 STRING         \"The North\"       3,15 - 3,25
 RPAREN         )                   3,26 - 3,26
 LBRACE         {                   3,28 - 3,28
 NAME           NobleHouse          4,7 - 4,16
 LPAREN         (                   4,17 - 4,17
 NAME           name                4,18 - 4,21
 COLON          :                   4,22 - 4,22
 STRING         \"Stark\"           4,23 - 4,29
 RPAREN         )                   4,30 - 4,30
 LBRACE         {                   4,31 - 4,31
 NAME           castle              5,9 - 5,14
 LBRACE         {                   5,15 - 5,15
 NAME           name                6,11 - 6,14
 RBRACE         }                   7,9 - 7,9
 NAME           members             8,9 - 8,15
 LBRACE         {                   8,16 - 8,16
 NAME           name                9,11 - 9,14
 NAME           alias               10,11 - 10,15
 RBRACE         }                   11,7 - 11,7
 RBRACE         }                   12,5 - 12,5
 RBRACE         }                   13,3 - 13,3
 RBRACE         }                   14,1 - 14,1
 ENDMARKER                          15,1 - 15,0
```

Parser
----------
```julia
using Diana

Parse("""
      #
      query {
        Region(name: "The North") {
          NobleHouse(name: "Stark") {
            castle {
              name
            }
            members{
              name
              alias
            }
          }
        }
      }
      """)
```
result:
```
 < Node :: Document ,definitions : Any[
 < Node :: OperationDefinition ,operation : query ,selectionSet :
 < Node :: SelectionSet ,selections : Main.Diana.Field[
 < Node :: Field ,name :
 < Node :: Name ,value : Region >  ,arguments : Main.Diana.Argument[
 < Node :: Argument ,name :
 < Node :: Name ,value : name >  ,value : (":",
 < Node :: StringValue ,value : "The North" > ) > ] ,selectionSet :
 < Node :: SelectionSet ,selections : Main.Diana.Field[
 < Node :: Field ,name :
 < Node :: Name ,value : NobleHouse >  ,arguments : Main.Diana.Argument[
 < Node :: Argument ,name :
 < Node :: Name ,value : name >  ,value : (":",
 < Node :: StringValue ,value : "Stark" > ) > ] ,selectionSet :
 < Node :: SelectionSet ,selections : Main.Diana.Field[
 < Node :: Field ,name :
 < Node :: Name ,value : castle >  ,selectionSet :
 < Node :: SelectionSet ,selections : Main.Diana.Field[
 < Node :: Field ,name :
 < Node :: Name ,value : name >  > ] >  > ,
 < Node :: Field ,name :
 < Node :: Name ,value : members >  ,selectionSet :
 < Node :: SelectionSet ,selections : Main.Diana.Field[
 < Node :: Field ,name :
 < Node :: Name ,value : name >  > ,
 < Node :: Field ,name :
 < Node :: Name ,value : alias >  > ] >  > ] >  > ] >  > ] >  > ] >
```

Execute
----------
```julia
using Diana

schema= """
        type Persona {
          nombre: String
          edad: Int
        }

        type Query {
          persona: Persona
          neomatrix: Persona
        }

        schema {
          query: Query
        }
        """

resolvers = Dict(
    "Query_neomatrix" => (obj, args, ctx, info) -> (return Dict("nombre" => "josue", "edad" => 5)),
    "Query_persona" => (obj, args, ctx, info) -> begin
        return Dict("nombre" => "Diana", "edad" => 15)
    end,
    "Persona_nombre" => (obj, args, ctx, info) -> (return ctx["nombre"]),
    "Persona_edad" => (obj, args, ctx, info) -> (return ctx["edad"])
    )

my_schema = Schema(schema, resolvers)

query = """
        query {
          neomatrix {
            nombre
          }
        }
        """
data = my_schema.execute(query)

```
result:
```
{"datos":{
  "neomatrix":{
    "nombre":"josue"
    }
  }
}"
```

```julia

query = """
        query {
          persona {
            nombre
          }
        }
        """

data = my_schema.execute(query)

```
result:
```
{"datos":{
  "persona":{
    "nombre":"Diana"
    }
  }
}
```
