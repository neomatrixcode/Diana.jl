<p align="center"><img src="diana-banner.png" width="25%" ></p>
<p align="center">
<strong>A Julia GraphQL server implementation.</strong>

[![License: MIT - Permissive License](https://img.shields.io/badge/License-MIT-blue.svg)](https://img.shields.io/badge/License-MIT-blue.svg)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Documentation: stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://codeneomatrix.github.io/Diana.jl/stable)
[![Documentation: dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://codeneomatrix.github.io/Diana.jl/dev)
[![Build Status](https://travis-ci.org/codeneomatrix/Diana.jl.svg?branch=master)](https://travis-ci.org/codeneomatrix/Diana.jl)
[![Code Coverage](https://codecov.io/gh/codeneomatrix/Diana.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/codeneomatrix/Diana.jl)
</p>

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

#### Contributions welcomed!

This repository is an implementation of a GraphQL server, a query language for API created by Facebook.
See more complete documentation at http://graphql.org/

Looking for help? Find resources from the community.

### Getting Started
An overview of GraphQL in general is available in the [README](https://github.com/facebook/graphql/blob/master/README.md) for the Specification for GraphQL.

This package is intended to help you building GraphQL schemas/types fast and easily.
+ **Easy to use:** Diana.jl helps you use GraphQL in Julia without effort.
+ **Data agnostic:** Diana.jl supports any type of data source: SQL, NoSQL, etc. The intent is to provide a complete API and make your data available through GraphQL.
+ **Make queries:** Diana.jl allows queries to graphql schemas

## Installation

```julia
Pkg> add Diana
#Release
pkg> add Diana#master
#Development
```

## Examples

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

## Documentation

Documentation and links to additional resources are available at
https://codeneomatrix.github.io/Diana.jl/stable