<img src="diana-banner.png" width="75%" border="0" align="center">

[![Build Status](https://travis-ci.org/codeneomatrix/Diana.jl.svg?branch=master)](https://travis-ci.org/codeneomatrix/Diana.jl)
[![Diana](http://pkg.julialang.org/badges/Diana_0.6.svg)](http://pkg.julialang.org/detail/Diana)

This repository is an implementation of a GraphQL server, a query language for API created by Facebook.
See more complete documentation at http://graphql.org/

Looking for help? Find resources from the community.

### Getting Started

An overview of GraphQL in general is available in the [README](https://github.com/facebook/graphql/blob/master/README.md) for the Specification for GraphQL.

This package is intended to help you building GraphQL schemas/types fast and easily.
+ Easy to use: Diana.jl helps you use GraphQL in Julia without effort.
+ Data agnostic: Diana.jl supports any type of data source: SQL, NoSQL, etc. The intent is to provide a complete API and make your data available through GraphQL.
+ Make querys: Diana.jl allows queries to graphql schemas

Roadmap
-----
#### Version 0.0.2
 + graphql client 

#### Version 0.0.3
  + Creation of schemas / types

### TODO
- [x] Client
- [x] Lexer
- [x] Parser
- [ ] Validator
- [ ] Schemas / Types
- [ ] Execute

### Contributing
Your pull requests are more than welcome!!!

Installing
----------
```julia
Pkg.add("Diana")                                           #Release
Pkg.clone("git://github.com/codeneomatrix/Diana.jl.git")   #Development
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

r = Query("https://neomatrix.herokuapp.com/graphql",query)
if (r.Info.status == 200) println(r.Data) end
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
using Diana

query = """
query(\$number_of_repos:Int!) {
  viewer {
    name
     repositories(last: \$number_of_repos) {
       nodes {
         name
       }
     }
   }
}
"""   

r = Query("https://api.github.com/graphql",query,vars= Dict("number_of_repos" => 3),auth="Bearer 7fe6d7e40cc191101b4708b078a5fcea35ee7280")
if (r.Info.status == 200) println(r.Data) end

```

### Query

```julia
using Diana

client = GraphQLClient("https://api.graph.cool/simple/v1/movies")
client.serverAuth("Bearer my-jwt-token")

or

client = GraphQLClient("https://api.graph.cool/simple/v1/movies","Bearer my-jwt-token")
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
if (r.Info.status == 200) println(r.Data) end
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
r = client.Query(query,vars= Dict("title" => "Inception"))

if (r.Info.status == 200) 
  println(r.Data) 
else
  println(r.Data)
end
```
### Change server
```julia
client.serverUrl("https://api.graph.cool/simple/v1/movies")
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
  Region(name:"The North") { 
      NobleHouse(name:"Stark"){
        castle{
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
  Region(name:"The North") { 
      NobleHouse(name:"Stark"){
        castle{
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
 (  kind : Document
 definitions : Any[
 (  kind : OperationDefinition
 operation : query
 selectionSet :
 (  kind : SelectionSet
 selections : Diana.Field[
 (  kind : Field
 name :
 (  kind : Name
 value : Region )
 arguments : Diana.Argument[
 (  Kind : Argument
 name :
 (  kind : Name
 value : name )
 value : (":",
 (  kind : StringValue
 value : "The North" ) ) ) ]
 selectionSet :
 (  kind : SelectionSet
 selections : Diana.Field[
 (  kind : Field
 name :
 (  kind : Name
 value : NobleHouse )
 arguments : Diana.Argument[
 (  Kind : Argument
 name :
 (  kind : Name
 value : name )
 value : (":",
 (  kind : StringValue
 value : "Stark" ) ) ) ]
 selectionSet :
 (  kind : SelectionSet
 selections : Diana.Field[
 (  kind : Field
 name :
 (  kind : Name
 value : castle )
 selectionSet :
 (  kind : SelectionSet
 selections : Diana.Field[
 (  kind : Field
 name :
 (  kind : Name
 value : name )
 ) ] )  ) ,
 (  kind : Field
 name :
 (  kind : Name
 value : members )
 selectionSet :
 (  kind : SelectionSet
 selections : Diana.Field[
 (  kind : Field
 name :
 (  kind : Name
 value : name )
 ) ,
 (  kind : Field
 name :
 (  kind : Name
 value : alias )
 ) ] )  ) ] )  ) ] )  ) ] )  ) ] )
```




