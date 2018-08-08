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

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": This anonymous operation must be the only defined operation.\n    }\n  ]\n}"

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

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": There can only be one operation named 'getName'.\n    }\n  ]\n}"

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

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": There can only be one operation named 'dogOperation'.\n    }\n  ]\n}"

query="""
subscription sub {
  newMessage {
    body
    sender
  }
  __typename
}"""

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"

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

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"

query= """
 subscription{
         ...multipleSubscriptions
         ...multipleSubscriptions
         }"""

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": subscription must select only one top level field\n    }\n  ]\n}"

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
@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Fragment nameFragment is not used.\n    }\n  ]\n}"

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
@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Unknown fragment fragmentotro.\n    }\n  ]\n}"

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

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": There can only be one fragment named 'dogFragment'.\n    }\n  ]\n}"

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

@test visitInParallel(Parse(query)) == "{\n  \"data\": null,\n  \"errors\": [\n    {\n      \"message\": Cannot spread fragment c within itself via ,ownerFragment,dogFragment,a,b.\n    }\n  ]\n"



