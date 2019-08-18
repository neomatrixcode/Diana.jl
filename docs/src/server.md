# Server


# Schemas and Types

## Type system

If you've seen a GraphQL query before, you know that the GraphQL query language is basically about selecting fields on objects. So, for example, in the following query:

```julia
{
  neomatrix{
  	nombre
  	edad
  }
}
```

1. We start with a special "root" object
2. We select the `neomatrix` field on that
3. For the object returned by `neomatrix`, we select the `nombre` and `edad` fields

Because the shape of a GraphQL query closely matches the result, you can predict what the query will return without knowing that much about the server. But it's useful to have an exact description of the data we can ask for - what fields can we select? What kinds of objects might they return? What fields are available on those sub-objects? That's where the schema comes in.

Every GraphQL service defines a set of types which completely describe the set of possible data you can query on that service. Then, when queries come in, they are validated and executed against that schema.


## Object types and fields

The most basic components of a GraphQL schema are object types, which just represent a kind of object you can fetch from your service, and what fields it has. In the GraphQL schema language, we might represent it like this:

```julia
type Persona {
  nombre: String
  edad: Int!
}
```

The language is pretty readable, but let's go over it so that we can have a shared vocabulary:

- `Persona` is a _GraphQL Object Type_, meaning it's a type with some fields. Most of the types in your schema will be object types.
- `nombre` and `edad` are _fields_ on the `Persona` type. That means that `nombre` and `edad` are the only fields that can appear in any part of a GraphQL query that operates on the `Persona` type.
- `String` is one of the built-in _scalar_ types - these are types that resolve to a single scalar object, and can't have sub-selections in the query. We'll go over scalar types more later.
- `Int!` means that the field is _non-nullable_, meaning that the GraphQL service promises to always give you a value when you query this field. In the type language, we'll represent those with an exclamation mark.

Now you know what a GraphQL object type looks like, and how to read the basics of the GraphQL type language.

## Arguments

Every field on a GraphQL object type can have zero or more arguments, for example the `edad` field below:

```julia
type Persona {
  nombre: String
  edad(valor:Int): Int!
}
```

All arguments are named. Unlike languages like JavaScript and Python where functions take a list of ordered arguments, all arguments in GraphQL are passed by name specifically. In this case, the `edad` field has one defined argument, `valor`.


## The Query and Mutation types

Most types in your schema will just be normal object types, but there are two types that are special within a schema:

```julia
schema {
  query: Query
  mutation: Mutation
}
```

Every GraphQL service has a `query` type and may or may not have a `mutation` type. These types are the same as a regular object type, but they are special because they define the _entry point_ of every GraphQL query. So if you see a query that looks like:

```julia
query{
    neomatrix{
    	nombre
    	altura
    }
    persona(id:"200"){
    	nombre
    	edad
    }
}
```

That means that the GraphQL service needs to have a `Query` type with `neomatrix` and `persona` fields:

```julia
type Query {
  neomatrix: Persona
  persona(id: ID!): Persona
}
```

Mutations work in a similar way - you define fields on the `Mutation` type, and those are available as the root mutation fields you can call in your query.

It's important to remember that other than the special status of being the "entry point" into the schema, the `Query` and `Mutation` types are the same as any other GraphQL object type, and their fields work exactly the same way.

## Scalar types

A GraphQL object type has a name and fields, but at some point those fields have to resolve to some concrete data. That's where the scalar types come in: they represent the leaves of the query.

In the following query, the `nombre` and `edad` fields will resolve to scalar types:

```julia

{
  neomatrix{
    nombre
    edad
  }
}
```

We know this because those fields don't have any sub-fields - they are the leaves of the query.

GraphQL comes with a set of default scalar types out of the box:

- `Int`: A signed 64‐bit integer.
- `Float`: A signed double-precision floating-point value.
- `String`: A UTF‐8 character sequence.
- `Boolean`: `true` or `false`.
- `ID`: The ID scalar type represents a unique identifier, often used to refetch an object or as the key for a cache. The ID type is serialized in the same way as a String; however, defining it as an `ID` signifies that it is not intended to be human‐readable.

## Input types

So far, we've only talked about passing scalar values as arguments into a field. But you can also easily pass complex objects. This is particularly valuable in the case of mutations, where you might want to pass in a whole object to be created. In the GraphQL schema language, input types look exactly the same as regular object types, but with the keyword `input` instead of `type`:

```julia
input DataInputType{
  nombre: String
  edad: Int
}
```

Here is how you could use the input object type in a mutation:

```julia

mutation mutationwithvariaribles(\$miedad: Int){
  addPerson(data: {nombre: "bob", edad: \$miedad}){
    nombre,
    edad
  }
}
```

The fields on an input object type can themselves refer to input object types, but you can't mix input and output types in your schema. Input object types also can't have arguments on their fields.


# Queries and Mutations
## Fields

At its simplest, GraphQL is about asking for specific fields on objects. Let's start by looking at a very simple query and the result we get when we run it:

```julia
{
  persona {
    nombre
  }
}
```

You can see immediately that the query has exactly the same shape as the result. This is essential to GraphQL, because you always get back what you expect, and the server knows exactly what fields the client is asking for.

The field `nombre` returns a `String` type.

> Oh, one more thing - the query above is *interactive*. That means you can change it as you like and see the new result. Try adding an `edad` field to the `persona` object in the query, and see the new result.

In the previous example, we just asked for the nombre of our persona which returned a String, but fields can also refer to Objects. In that case, you can make a *sub-selection* of fields for that object. GraphQL queries can traverse related objects and their fields, letting clients fetch lots of related data in one request, instead of making several roundtrips as one would need in a classic REST architecture.


## Arguments

If the only thing we could do was traverse objects and their fields, GraphQL would already be a very useful language for data fetching. But when you add the ability to pass arguments to fields, things get much more interesting.

```julia
{
  persona(id: "1000") {
    nombre
    altura
  }
}
```

In a system like REST, you can only pass a single set of arguments - the query parameters and URL segments in your request. But in GraphQL, every field and nested object can get its own set of arguments, making GraphQL a complete replacement for making multiple API fetches. You can even pass arguments into scalar fields, to implement data transformations once on the server, instead of on every client separately.

```julia
{
  persona(id: "1000") {
    nombre
    altura(unidad: String)
  }
}
```

Arguments can be of many different types.

[Read more about the GraphQL type system here.](https://graphql.org/learn/schema)


## Operation name

Up until now, we have been using a shorthand syntax where we omit both the `query` keyword and the query name, but in production apps it's useful to use these to make our code less ambiguous.

Here’s an example that includes the keyword `query` as _operation type_ and `PersonaNombreandEdad` as _operation name_ :

```julia

query PersonaNombreandEdad {
  persona {
    name
    edad
  }
}
```

The _operation type_ is either _query_, _mutation_, or _subscription_ and describes what type of operation you're intending to do. The operation type is required unless you're using the query shorthand syntax, in which case you can't supply a name or variable definitions for your operation.

The _operation name_ is a meaningful and explicit name for your operation. It is only required in multi-operation documents, but its use is encouraged because it is very helpful for debugging and server-side logging.
When something goes wrong either in your network logs or your GraphQL server, it is easier to identify a query in your codebase by name instead of trying to decipher the contents.
Think of this just like a function name in your favorite programming language.
For example, in JavaScript we can easily work only with anonymous functions, but when we give a function a name, it's easier to track it down, debug our code,
and log when it's called. In the same way, GraphQL query and mutation names, along with fragment names, can be a useful debugging tool on the server side to identify
different GraphQL requests.

## Variables

So far, we have been writing all of our arguments inside the query string. But in most applications, the arguments to fields will be dynamic: For example, there might be a dropdown, or a search field, or a set of filters.

It wouldn't be a good idea to pass these dynamic arguments directly in the query string, because then our client-side code would need to dynamically manipulate the query string at runtime, and serialize it into a GraphQL-specific format. Instead, GraphQL has a first-class way to factor dynamic values out of the query, and pass them as a separate dictionary. These values are called _variables_.

When we start working with variables, we need to do three things:

1. Replace the static value in the query with `$variableName`
2. Declare `$variableName` as one of the variables accepted by the query
3. Pass `variableName: value` in the separate, transport-specific (JSON) variables dictionary

Here's what it looks like all together:

```julia

query PersonaNombreandEdad($identificador: ID) {
  persona(id: $identificador) {
    nombre
    edad
  }
}
```

Now, in our client code, we can simply pass a different variable rather than needing to construct an entirely new query. This is also in general a good practice for denoting which arguments in our query are expected to be dynamic - we should never be doing string interpolation to construct queries from user-supplied values.


## Variable definitions

The variable definitions are the part that looks like `($identificador: ID)` in the query above. It works just like the argument definitions for a function in a typed language. It lists all of the variables, prefixed by `$`, followed by their type, in this case `ID`.

All declared variables must be either scalars, or input object types. So if you want to pass a complex object into a field, you need to know what input type that matches on the server. Learn more about input object types on the Schemas and Types seccion.

Variable definitions can be optional or required. In the case above, since there isn't an `!` next to the `ID` type, it's optional. But if the field you are passing the variable into requires a non-null argument, then the variable has to be required as well.

To learn more about the syntax for these variable definitions, it's useful to learn the GraphQL schema language. The schema language is explained in detail on the Schemas and Types seccion.


## Mutations

Most discussions of GraphQL focus on data fetching, but any complete data platform needs a way to modify server-side data as well.

In REST, any request might end up causing some side-effects on the server, but by convention it's suggested that one doesn't use `GET` requests to modify data. GraphQL is similar - technically any query could be implemented to cause a data write. However, it's useful to establish a convention that any operations that cause writes should be sent explicitly via a mutation.

Just like in queries, if the mutation field returns an object type, you can ask for nested fields. This can be useful for fetching the new state of an object after an update. Let's look at a simple example mutation:

```julia
mutation mutationwithvariables(\$dato: DataInputType){
  addPerson(data: \$dato ){
    nombre,
    edad
  }
}
"""
```

Note how `addPerson` field returns the `nombre` and `edad` fields of the newly created review. This is especially useful when mutating existing data, for example, when incrementing a field, since we can mutate and query the new value of the field with one request.

You might also notice that, in this example, the `data` variable we passed in is not a scalar. It's an _input object type_, a special kind of object type that can be passed in as an argument. Learn more about input types on the Schemas and Types seccion.

## Multiple fields in mutations

A mutation can contain multiple fields, just like a query. There's one important distinction between queries and mutations, other than the name:

**While query fields are executed in parallel (in this version the execution is in series), mutation fields run in series, one after the other.**

This means that if we send two `incrementCredits` mutations in one request, the first is guaranteed to finish before the second begins, ensuring that we don't end up with a race condition with ourselves.

# Execution

After being validated, a GraphQL query is executed by a GraphQL server which returns a result that mirrors the shape of the requested query, as JSON.

GraphQL cannot execute a query without a type system, let's use an example type system to illustrate executing a query. This is a part of the same type system used throughout the examples in these articles:

```julia
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
```

In order to describe what happens when a query is executed, let's use an example to walk through.

```julia
query{
  neomatrix{
  	nombre
  }
}
```

You can think of each field in a GraphQL query as a function or method of the previous type which returns the next type. In fact, this is exactly how GraphQL works. Each field on each type is backed by a function called the *resolver* which is provided by the GraphQL server developer. When a field is executed, the corresponding *resolver* is called to produce the next value.

If a field produces a scalar value like a string or number, then the execution completes. However if a field produces an object value then the query will contain another selection of fields which apply to that object. This continues until scalar values are reached. GraphQL queries always end at scalar values.


## Root fields & resolvers

At the top level of every GraphQL server is a type that represents all of the possible entry points into the GraphQL API, it's often called the *Root* type or the *Query* type.

In this example, our Query type provides a field called `persona` which accepts the argument `nombre`. The resolver function for this field likely accesses a database and then constructs and returns a `Persona` object.

```js
resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
        	return Dict("nombre"=>"josue","edad"=>25,"altura"=>10.5,"spooilers"=>false)
        	)
        ,"persona" => (root,args,ctx,info)->(
        	return Dict("nombre"=>"Diana","edad"=>14,"altura"=>11.8,"spooilers"=>true)
        	)
    )
)
```

 A resolver function receives four arguments:

- `root` The previous object, which for a field on the root Query type is often not used.
- `args` The arguments provided to the field in the GraphQL query.
- `context` A value which is provided to every resolver and holds important contextual information like the currently logged in user, or access to a database.
- `info` A value which holds field-specific information relevant to the current query as well as the schema details.


## Trivial resolvers

Now that a `Persona` object is available, GraphQL execution can continue with the fields requested on it.

```js
resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(
        	return Dict("nombre"=>"josue","edad"=>25,"altura"=>10.5,"spooilers"=>false)
        	)
        ,"persona" => (root,args,ctx,info)->(
        	return Dict("nombre"=>"Diana","edad"=>14,"altura"=>11.8,"spooilers"=>true)
        	)
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(
      	return root["edad"])
    )
)
```

A GraphQL server is powered by a type system which is used to determine what to do next. Even before the `persona` field returns anything, GraphQL knows that the next step will be to resolve fields on the `Persona` type since the type system tells it that the `persona` field will return a `Persona`.

Resolving age in this case is very straight-forward. The name resolver function is called and the `root` argument is the `new Persona` object returned from the previous field. In this case, we expect that Human object to have a `edad` property which we can read and return directly.

In fact, Diana will allow you to skip resolvers that simple and will simply assume that if a resolver is not provided for a field, a property of the same name must be read and returned


## Producing the result

As each field is resolved, the resulting value is placed into a dictionary with the field name as the key and the resolved value as the value, this continues from the bottom leaf fields of the query all the way back up to the original field on the root Query type. Collectively these produce a structure that mirrors the original query which can then be sent (JSON) to the client which requested it.

Let's take one last look at the original query to see how all these resolving functions produce a result:

```julia
{
  persona{
    nombre
  }
}
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

# Tools

The lexer is built based on the [Tokenize](https://github.com/KristofferC/Tokenize.jl) package code and the Parser on the [graphql-js](https://github.com/graphql/graphql-js) package
**Thanks people**

## Parser
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
 < Node :: Document ,definitions : Diana.Node[
 < Node :: OperationDefinition ,operation : query ,selectionSet :
 < Node :: SelectionSet ,selections : Diana.Node[
 < Node :: Field ,name :
 < Node :: Name ,value : Region >  ,arguments : Diana.Argument[
 < Node :: Argument ,name :
 < Node :: Name ,value : name >  ,value : (":",
 < Node :: StringValue ,value : The North > ) > ] ,selectionSet :
 < Node :: SelectionSet ,selections : Diana.Node[
 < Node :: Field ,name :
 < Node :: Name ,value : NobleHouse >  ,arguments : Diana.Argument[
 < Node :: Argument ,name :
 < Node :: Name ,value : name >  ,value : (":",
 < Node :: StringValue ,value : Stark > ) > ] ,selectionSet :
 < Node :: SelectionSet ,selections : Diana.Node[
 < Node :: Field ,name :
 < Node :: Name ,value : castle >  ,selectionSet :
 < Node :: SelectionSet ,selections : Diana.Node[
 < Node :: Field ,name :
 < Node :: Name ,value : name >  > ] >  > ,
 < Node :: Field ,name :
 < Node :: Name ,value : members >  ,selectionSet :
 < Node :: SelectionSet ,selections : Diana.Node[
 < Node :: Field ,name :
 < Node :: Name ,value : name >  > ,
 < Node :: Field ,name :
 < Node :: Name ,value : alias >  > ] >  > ] >  > ] >  > ] >  > ] >
```

## Lexer

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
 NAME           query               2,15 - 2,19
 LBRACE         {                   2,21 - 2,21
 NAME           Region              3,31 - 3,36
 LPAREN         (                   3,37 - 3,37
 NAME           name                3,38 - 3,41
 COLON          :                   3,42 - 3,42
 STRING         The North           3,44 - 3,54
 RPAREN         )                   3,55 - 3,55
 LBRACE         {                   3,57 - 3,57
 NAME           NobleHouse          4,49 - 4,58
 LPAREN         (                   4,59 - 4,59
 NAME           name                4,60 - 4,63
 COLON          :                   4,64 - 4,64
 STRING         Stark               4,66 - 4,72
 RPAREN         )                   4,73 - 4,73
 LBRACE         {                   4,75 - 4,75
 NAME           castle              5,69 - 5,74
 LBRACE         {                   5,76 - 5,76
 NAME           name                6,91 - 6,94
 RBRACE         }                   7,111 - 7,111
 NAME           members             8,131 - 8,137
 LBRACE         {                   8,139 - 8,139
 NAME           name                9,153 - 9,156
 NAME           alias               10,175 - 10,179
 RBRACE         }                   11,195 - 11,195
 RBRACE         }                   12,213 - 12,213
 RBRACE         }                   13,229 - 13,229
 RBRACE         }                   14,243 - 14,243
 ENDMARKER                          15,257 - 15,257
```


