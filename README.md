# Diana.jl  
[![Build Status](https://travis-ci.org/codeneomatrix/Diana.jl.svg?branch=master)](https://travis-ci.org/codeneomatrix/Diana.jl)

This repository is an implementation of a GraphQL server, a query language for API created by Facebook.
See more complete documentation at http://graphql.org/

Looking for help? Find resources from the community.

### Getting Started

An overview of GraphQL in general is available in the [README](https://github.com/facebook/graphql/blob/master/README.md) for the Specification for GraphQL.

This package is intended to help you building GraphQL schemas/types fast and easily.
+ Easy to use: Diana.jl helps you used GraphQL in Julia without effort.
+ Data agnostic: Diana.jl supports any type of data source: SQL, NoSQL, etc. The intent is to provide a complete API and make your data available through GraphQL.
+ Make querys: Diana.jl allows queries to graphql schemas

Roadmap
-----
#### Version 0.0.1
 + graphql client 

#### Version 0.0.2
  + Creation of schemas / types

Installing
----------
```julia
Pkg.add("Diana")                                           #Release
Pkg.clone("git://github.com/codeneomatrix/Diana.jl.git")   #Development
```

### Simple query

```julia
using Diana

Query = """
{
  neomatrix{
    nombre
    linkedin
  }
} 
"""   

query("https://neomatrix.herokuapp.com/graphql",Query)

```

### Query

```julia
using Diana

Query = """
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
vars= Dict("number_of_repos" => 3)
auth= "Bearer 7fe6d7e40cc191101b4708b078a5fcea35ee7280"

query("https://api.github.com/graphql",Query,auth,vars)
```

## Contributing
Features are welcome !!

