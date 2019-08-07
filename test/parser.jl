a= Tokensgraphql("""
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

s=""
next = iterate(a)
while next !== nothing
  global next
  global s
    (i, state) = next
   s*= " $(i.kind) $(i.val) ($(i.startpos) , $(i.endpos) ) \n"
   next = iterate(a, state)
end
@test s == " NAME query ((2, 1) , (2, 5) ) \n LBRACE { ((2, 7) , (2, 7) ) \n NAME Region ((3, 3) , (3, 8) ) \n LPAREN ( ((3, 9) , (3, 9) ) \n NAME name ((3, 10) , (3, 13) ) \n COLON : ((3, 14) , (3, 14) ) \n STRING \"The North\" ((3, 15) , (3, 25) ) \n RPAREN ) ((3, 26) , (3, 26) ) \n LBRACE { ((3, 28) , (3, 28) ) \n NAME NobleHouse ((4, 7) , (4, 16) ) \n LPAREN ( ((4, 17) , (4, 17) ) \n NAME name ((4, 18) , (4, 21) ) \n COLON : ((4, 22) , (4, 22) ) \n STRING \"Stark\" ((4, 23) , (4, 29) ) \n RPAREN ) ((4, 30) , (4, 30) ) \n LBRACE { ((4, 31) , (4, 31) ) \n NAME castle ((5, 9) , (5, 14) ) \n LBRACE { ((5, 15) , (5, 15) ) \n NAME name ((6, 11) , (6, 14) ) \n RBRACE } ((7, 9) , (7, 9) ) \n NAME members ((8, 9) , (8, 15) ) \n LBRACE { ((8, 16) , (8, 16) ) \n NAME name ((9, 11) , (9, 14) ) \n NAME alias ((10, 11) , (10, 15) ) \n RBRACE } ((11, 7) , (11, 7) ) \n RBRACE } ((12, 5) , (12, 5) ) \n RBRACE } ((13, 3) , (13, 3) ) \n RBRACE } ((14, 1) , (14, 1) ) \n ENDMARKER eof ((15, 1) , (15, 1) ) \n"


#=b= Tokensgraphql(
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
""")

s=""
next = iterate(b)
while next !== nothing
  global next
  global s
    (i, state) = next
   next = iterate(b, state)
end
@test s == ""
=#
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
        s=string(e)
        @test s ==  "ErrorException(\"{\\\"errors\\\":[{\\\"locations\\\": [{\\\"column\\\": 1,\\\"line\\\": 2}],\\\"message\\\": \\\"Syntax Error GraphQL request (1:2) Unexpected character % \\\"}]}\")"
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