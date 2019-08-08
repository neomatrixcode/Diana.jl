
try
Parse("""
#
% {
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
catch e
  if e isa Diana.Lexing.ErrorGraphql
     s=string(e)
        @test s ==  "Diana.Lexing.ErrorGraphql(\"{\\\"errors\\\":[{\\\"locations\\\": [{\\\"column\\\": 1,\\\"line\\\": 2}],\\\"message\\\": \\\"Syntax Error GraphQL request (2:1) Unexpected character % \\\"}]}\")"
  end
end

try
Parse("""
#
query {
  Region(name:"The North") {
      NobleHouse(name:"Stark"){
        castle{
          }name
        }
        members{
          name
          alias
      }
    }
  }
}
""")
catch e
        s=string(e)
        @test s == "ErrorException(\"{\\\"errors\\\":[{\\\"locations\\\": [{\\\"column\\\": 11,\\\"line\\\": 6}],\\\"message\\\": \\\"Syntax Error GraphQL request (11:6) Expected NAME, found } \\\"}]}\")"
      end


@test "$(Parse(
"""
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
"""))" == "\n\e[33m < \e[37mNode :: Document ,definitions : Any[\n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mQuery\e[37m\e[33m > \e[37m ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mdog\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDog\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: EnumTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDogCommand\e[37m\e[33m > \e[37m ,_values : Diana.EnumValueDefinition[\n\e[33m < \e[37mNode :: EnumValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mSIT\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: EnumValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDOWN\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: EnumValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mHEEL\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDog\e[37m\e[33m > \e[37m ,interfaces : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mPet\e[37m\e[33m > \e[37m\e[33m > \e[37m] ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mnickname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mbarkVolume\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mInt\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mdoesKnowCommand\e[37m\e[33m > \e[37m ,arguments : Diana.InputValueDefinition[\n\e[33m < \e[37mNode :: InputValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mdogCommand\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDogCommand\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m] ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mBoolean\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92misHousetrained\e[37m\e[33m > \e[37m ,arguments : Diana.InputValueDefinition[\n\e[33m < \e[37mNode :: InputValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92matOtherHomes\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mBoolean\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m] ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mBoolean\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mowner\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mHuman\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: InterfaceTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mSentient\e[37m\e[33m > \e[37m ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: InterfaceTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mPet\e[37m\e[33m > \e[37m ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mAlien\e[37m\e[33m > \e[37m ,interfaces : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mSentient\e[37m\e[33m > \e[37m\e[33m > \e[37m] ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mhomePlanet\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mHuman\e[37m\e[33m > \e[37m ,interfaces : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mSentient\e[37m\e[33m > \e[37m\e[33m > \e[37m] ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: EnumTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mCatCommand\e[37m\e[33m > \e[37m ,_values : Diana.EnumValueDefinition[\n\e[33m < \e[37mNode :: EnumValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mJUMP\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mCat\e[37m\e[33m > \e[37m ,interfaces : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mPet\e[37m\e[33m > \e[37m\e[33m > \e[37m] ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mnickname\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mdoesKnowCommand\e[37m\e[33m > \e[37m ,arguments : Diana.InputValueDefinition[\n\e[33m < \e[37mNode :: InputValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mcatCommand\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mCatCommand\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m] ,tipe : \n\e[33m < \e[37mNode :: NonNullType ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mBoolean\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mmeowVolume\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mInt\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: UnionTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mCatOrDog\e[37m\e[33m > \e[37m ,tipes : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mCat\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDog\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: UnionTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDogOrHuman\e[37m\e[33m > \e[37m ,tipes : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mDog\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mHuman\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: UnionTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mHumanOrAlien\e[37m\e[33m > \e[37m ,tipes : Any[\n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mHuman\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mAlien\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m]\e[33m > \e[37m"