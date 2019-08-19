<p align="center"><img src="diana-banner.png" width="25%" ></p>
<p align="center">
<strong>A Julia GraphQL client/server implementation.</strong>
<br><br>
<a href="https://travis-ci.org/codeneomatrix/Diana.jl"><img src="https://travis-ci.org/codeneomatrix/Diana.jl.svg?branch=master"></a>
<a href="https://codecov.io/gh/codeneomatrix/Diana.jl">
  <img src="https://codecov.io/gh/codeneomatrix/Diana.jl/branch/master/graph/badge.svg" />
</a>
<a href="https://codeneomatrix.github.io/Diana.jl/stable"><img src="https://img.shields.io/badge/docs-stable-blue.svg"></a>
<a href="https://codeneomatrix.github.io/Diana.jl/dev"><img src="https://img.shields.io/badge/docs-dev-blue.svg"></a>
<a href="https://www.repostatus.org/#active"><img src="https://www.repostatus.org/badges/latest/active.svg"></a>
<a href="https://raw.githubusercontent.com/codeneomatrix/Diana.jl/master/LICENSE.md"><img src="https://img.shields.io/badge/License-MIT-blue.svg"></a>
</p>

#### Contributions welcomed!

This repository is an implementation of a GraphQL server, a query language for API created by Facebook.
See more complete documentation at http://graphql.org/

Looking for help? Find resources from the community.

### Getting Started
An overview of GraphQL in general is available in the [README](https://github.com/facebook/graphql/blob/master/README.md) for the Specification for GraphQL.

This package is intended to help you building GraphQL schemas/types fast and easily.
+ **Easy to use:** Diana.jl helps you use GraphQL in Julia without effort.
+ **Data agnostic:** Diana.jl supports any type of data source: SQL, NoSQL, etc. The intent is to provide a complete API and make your data available through GraphQL.
+ **Make queries:** Diana.jl allows queries to graphql schemas.

## Installation

```julia
Pkg> add Diana
#Release
pkg> add Diana#master
#Development
```

## Examples
Client
-------
```julia
query = """
{
  neomatrix{
    nombre
    linkedin
  }
}
"""

r = Queryclient("https://neomatrix.herokuapp.com/graphql",query)
```

```julia
client = GraphQLClient("https://api.graph.cool/simple/v1/movies",auth="Bearer my-jwt-token")

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

r.Data 
# "{\"data\":{\"Movie\":{\"releaseDate\":\"2010-08-28T20:00:00.000Z\",\"actors\":[{\"name\":\"Leonardo DiCaprio\"},{\"name\":\"Ellen Page\"},{\"name\":\"Tom Hardy\"},{\"name\":\"Joseph Gordon-Levitt\"},{\"name\":\"Marion Cotillard\"}]}}}"

```

Server
-------
Here is one example for you to get started:

```julia
schema = Dict(
"query" => "Query"

,"Query"=> Dict(
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
        "neomatrix" => (root,args,ctx,info)->(return Dict("nombre"=>"josue","edad"=>26))
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>25))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
)

my_schema = Schema(schema, resolvers)
```

Then Querying `Diana.Schema` is as simple as:

```julia
query= """
{
  neomatrix{
  	nombre
  }
}
"""
result = my_schema.execute(query)
# "{\"data\":{\"neomatrix\":{\"nombre\":\"josue\"}}}"
```
## TODO
- [x] Client
- [x] Lexer
- [x] Parser
- [x] Query validation
- [x] Schemas / Types
- [x] Query execution
  - [x] Arguments
  - [x] Scalar types
  - [x] Multiple forms of resolution
  - [x] Extract variable values
  - [ ] Complex types (List, Object, etc)
  - [ ] Fragments in queries
  - [ ] Directives
- [x] Mutation execution
- [ ] Subscriptions execution
- [ ] Introspection
- [ ] Depth of the query
- [ ] Middleware

## Documentation

Documentation and links to additional resources are available at
https://codeneomatrix.github.io/Diana.jl/v0.2/
