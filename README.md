# Diana.jl  

This repository is an implementation of a GraphQL server, a query language for API created by Facebook.

See more complete documentation at http://graphql.org/

Looking for help? Find resources from the community.

### Getting Started

An overview of GraphQL in general is available in the [README](https://github.com/facebook/graphql/blob/master/README.md) for the Specification for GraphQL.


This package is intended to help you building GraphQL schemas/types fast and easily.
+ Easy to use: Diana.jl helps you used GraphQL in Julia without effort.
+ Data agnostic: Diana.jl supports any type of data source: SQL, NoSQL, etc. The intent is to provide a complete API and make your data available through GraphQL.
+ Make querys: Diana.jl allows queries to graphql schemas

### Using Diana.jl

Diana.jl provides three important capabilities: building a type schema, serving queries against that type schema and consult schemes

Installing
----------
```julia
Pkg.clone("git://github.com/codeneomatrix/Diana.jl.git")   #Development
```

### Query

```julia
query("https://neomatrix.herokuapp.com/graphql","{ neomatrix{ nombre linkedin } }")
```


### Contributing
Features are welcome !!

