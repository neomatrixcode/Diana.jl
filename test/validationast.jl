query="""
extend type Hello {
  world2: String
}
"""
@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": GraphQL cannot execute a request containing a TypeExtensionDefinition.\n    }\n  ]\n}"

query="""
type Hello {
  world2: String
}
"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": GraphQL cannot execute a request containing a ObjectTypeDefinition.\n    }\n  ]\n}"

query="""
schema {
    query: RootQuery
  }
"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": GraphQL cannot execute a request containing a SchemaDefinition.\n    }\n  ]\n}"

query="""
{
  dog {
    name
  }
}

query getName {
  dog {
    owner {
      name
    }
  }
}"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": This anonymous operation must be the only defined operation.\n    }\n  ]\n}"

query="""
query getName {
  dog {
    name
  }
}

query getName {
  dog {
    owner {
      name
    }
  }
}"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": There can only be one operation named 'getName'.\n    }\n  ]\n}"

query="""
query dogOperation {
  dog {
    name
  }
}

mutation dogOperation {
  mutateDog {
    id
  }
}"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": There can only be one operation named 'dogOperation'.\n    }\n  ]\n}"

query="""
subscription sub {
  newMessage {
    body
    sender
  }
  __typename
}"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"

query="""
subscription JAJA {
         Actor(
         filter: {
           mutation_in:[CREATED]
           }){
             updatedFields
             }
               File
               }"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"


query= """
fragment multipleSubscriptions on Subscription {
  newMessage {
    body
    sender
  }
  disallowedSecondRootField
}"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"

query= """
 subscription{
         ...multipleSubscriptions
         ...multipleSubscriptions
         }"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"

query = """
fragment nameFragment on Dog { # unused
  name
}

{
  dog {
    name
  }
}
                 """
@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Fragment nameFragment is not used.\n    }\n  ]\n}"



query = """
  {
         dog {
             ...fragmentOne
               ...fragmentotro
               }
               }
               fragment fragmentOne on Dog {
                 name
                 }
                 """
@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Unknown fragment fragmentotro.\n    }\n  ]\n}"

query = """
 fragment fragmentOne on Dog {
                 name
                 }

  {
         dog {
             ...fragmentOne
               ...fragmentotro
               }
               }

                 """
@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Unknown fragment fragmentotro.\n    }\n  ]\n}"

query = """
       {
         dog {
             ...dogFragment

               }
               }
               fragment dogFragment on Dog {
                 name
                   owner {
                       ...a
                         }
                         }

                         fragment dogFragment on Dog {
                           name
                             pets {
                                 ...dogFragment
                                   }
                                   }
"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": There can only be one fragment named 'dogFragment'.\n    }\n  ]\n}"

query = """
       {
         dog {
             ...dogFragment

               }
               }
               fragment dogFragment on Dog {
                 name
                   owner {
                       ...a
                         }
                         }

                         fragment ownerFragment on Dog {
                           name
                             pets {
                                 ...dogFragment
                                   }
                                   }
           fragment a on Dog{
           ...b
           }
           fragment b on Dog{
           ...c
           }
           fragment c on Dog{
           ...ownerFragment
           }"""

@test Validatequery(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Cannot spread fragment dogFragment within itself via  ownerFragment a b c.\n    }\n  ]\n}"


query= """
       {
         dog {
             name
               }
               }"""

@test Validatequery(Parse(query)) == "ok"
