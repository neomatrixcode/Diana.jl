
query= """
       {
         dog {
             name
               }
               }"""

@time Validatequery(Parse(query)) == "ok"

query= """
type Query {
  dog: Dog
}

enum DogCommand { SIT, DOWN, HEEL }

type Dog implements Pet {
  name: String!
  nickname: String
  barkVolume: Int
  doesKnowCommand(dogCommand: DogCommand!): Boolean!
  isHousetrained(atOtherHomes: Boolean): Boolean!
  owner: Human
}

interface Sentient {
  name: String!
}

interface Pet {
  name: String!
}

type Alien implements Sentient {
  name: String!
  homePlanet: String
}

type Human implements Sentient {
  name: String!
}

enum CatCommand { JUMP }

type Cat implements Pet {
  name: String!
  nickname: String
  doesKnowCommand(catCommand: CatCommand!): Boolean!
  meowVolume: Int
}

union CatOrDog = Cat | Dog
union DogOrHuman = Dog | Human
union HumanOrAlien = Human | Alien
"""

@time Validatequery(Parse(query)) == "ok"


query="""
extend type Hello {
  world2: String
}
"""
try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e.msg) =="{\"data\": null,\"errors\": [{\"message\": \"GraphQL cannot execute a request containing a TypeExtensionDefinition.\"}]}"
  end
end

query="""
type Hello {
  world2: String
}
"""
try
 Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"GraphQL cannot execute a request containing a ObjectTypeDefinition.\\\"}]}\")"
  end
end

query="""
schema {
    query: RootQuery
  }
"""

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"GraphQL cannot execute a request containing a SchemaDefinition.\\\"}]}\")"
  end
end

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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"This anonymous operation must be the only defined operation.\\\"}]}\")"
  end
end

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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"There can only be one operation named 'getName'.\\\"}]}\")"
  end
end

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


try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"There can only be one operation named 'dogOperation'.\\\"}]}\")"
  end
end

query="""
subscription sub {
  newMessage {
    body
    sender
  }
  __typename
}"""

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) == "Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"subscription must select only one top level field.\\\"}]}\")"
  end
end

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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"subscription must select only one top level field.\\\"}]}\")"
  end
end

query= """
fragment multipleSubscriptions on Subscription {
  newMessage {
    body
    sender
  }
  disallowedSecondRootField
}"""

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"subscription must select only one top level field\\\"}]}\")"
  end
end

query= """
 subscription{
         ...multipleSubscriptions
         ...multipleSubscriptions
         }"""

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"subscription must select only one top level field.\\\"}]}\")"
  end
end

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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"Fragment  nameFragment is not used.\\\"}]}\")"
  end
end


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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"Unknown fragment  fragmentotro.\\\"}]}\")"
  end
end

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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) == "Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"Unknown fragment  fragmentotro.\\\"}]}\")"
  end
end

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

try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"There can only be one fragment named 'dogFragment'.\\\"}]}\")"
  end
end

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


try
  Validatequery(Parse(query))
catch e
  if e isa Diana.GraphQLError
    @test string(e) =="Diana.GraphQLError(\"{\\\"data\\\": null,\\\"errors\\\": [{\\\"message\\\": \\\"Cannot spread fragment dogFragment within itself via  ownerFragment a b c.\\\"}]}\")"
  end
end