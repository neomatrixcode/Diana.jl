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



b=Tokensgraphql(
"""
{
  leftComparison: hero(episode: EMPIRE) {
    ...comparisonFields
  }
  rightComparison: hero(episode: JEDI) {
    ...comparisonFields
  }
}

fragment comparisonFields on Character {
  name
  appearsIn
  friends {
    name
  }
}
""")

s=""
next = iterate(b)
while next !== nothing
  global next
  global s
    (i, state) = next
    s*= " $(i.kind) $(i.val) ($(i.startpos) , $(i.endpos) ) \n"
   next = iterate(b, state)
end
@test s == " LBRACE { ((1, 1) , (1, 1) ) \n NAME leftComparison ((2, 3) , (2, 16) ) \n COLON : ((2, 17) , (2, 17) ) \n NAME hero ((2, 19) , (2, 22) ) \n LPAREN ( ((2, 23) , (2, 23) ) \n NAME episode ((2, 24) , (2, 30) ) \n COLON : ((2, 31) , (2, 31) ) \n NAME EMPIRE ((2, 33) , (2, 38) ) \n RPAREN ) ((2, 39) , (2, 39) ) \n LBRACE { ((2, 41) , (2, 41) ) \n SPREAD ... ((3, 5) , (3, 5) ) \n NAME comparisonFields ((3, 6) , (3, 21) ) \n RBRACE } ((4, 3) , (4, 3) ) \n NAME rightComparison ((5, 3) , (5, 17) ) \n COLON : ((5, 18) , (5, 18) ) \n NAME hero ((5, 20) , (5, 23) ) \n LPAREN ( ((5, 24) , (5, 24) ) \n NAME episode ((5, 25) , (5, 31) ) \n COLON : ((5, 32) , (5, 32) ) \n NAME JEDI ((5, 34) , (5, 37) ) \n RPAREN ) ((5, 38) , (5, 38) ) \n LBRACE { ((5, 40) , (5, 40) ) \n SPREAD ... ((6, 5) , (6, 5) ) \n NAME comparisonFields ((6, 6) , (6, 21) ) \n RBRACE } ((7, 3) , (7, 3) ) \n RBRACE } ((8, 1) , (8, 1) ) \n NAME fragment ((10, 1) , (10, 8) ) \n NAME comparisonFields ((10, 10) , (10, 25) ) \n NAME on ((10, 27) , (10, 28) ) \n NAME Character ((10, 30) , (10, 38) ) \n LBRACE { ((10, 40) , (10, 40) ) \n NAME name ((11, 3) , (11, 6) ) \n NAME appearsIn ((12, 3) , (12, 11) ) \n NAME friends ((13, 3) , (13, 9) ) \n LBRACE { ((13, 11) , (13, 11) ) \n NAME name ((14, 5) , (14, 8) ) \n RBRACE } ((15, 3) , (15, 3) ) \n RBRACE } ((16, 1) , (16, 1) ) \n ENDMARKER eof ((17, 1) , (17, 1) ) \n"

b=Tokensgraphql(
"""
mutation {
  sendEmail(message: \"\"\"
    Hello,
      World!

    Yours,
      GraphQL.
  \"\"\")
}
""")

s=""
next = iterate(b)
while next !== nothing
  global next
  global s
    (i, state) = next
    s*= " $(i.kind) $(i.val) ($(i.startpos) , $(i.endpos) ) \n"
   next = iterate(b, state)
end
@test s ==  " NAME mutation ((1, 1) , (1, 8) ) \n LBRACE { ((1, 10) , (1, 10) ) \n NAME sendEmail ((2, 3) , (2, 11) ) \n LPAREN ( ((2, 12) , (2, 12) ) \n NAME message ((2, 13) , (2, 19) ) \n COLON : ((2, 20) , (2, 20) ) \n STRING \"\n    Hello,\n      World!\n\n    Yours,\n      GraphQL.\n  \" ((2, 22) , (8, 6) ) \n RPAREN ) ((8, 7) , (8, 7) ) \n RBRACE } ((9, 1) , (9, 1) ) \n ENDMARKER eof ((10, 1) , (10, 1) ) \n"

b= Tokensgraphql(
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
    s*= " $(i.kind) $(i.val) ($(i.startpos) , $(i.endpos) ) \n"
   next = iterate(b, state)
end
@test s == " NAME type ((1, 1) , (1, 4) ) \n NAME Query ((1, 6) , (1, 10) ) \n LBRACE { ((1, 12) , (1, 12) ) \n NAME dog ((2, 3) , (2, 5) ) \n COLON : ((2, 6) , (2, 6) ) \n NAME Dog ((2, 8) , (2, 10) ) \n RBRACE } ((3, 1) , (3, 1) ) \n NAME enum ((5, 1) , (5, 4) ) \n NAME DogCommand ((5, 6) , (5, 15) ) \n LBRACE { ((5, 17) , (5, 17) ) \n NAME SIT ((5, 19) , (5, 21) ) \n NAME DOWN ((5, 24) , (5, 27) ) \n NAME HEEL ((5, 30) , (5, 33) ) \n RBRACE } ((5, 35) , (5, 35) ) \n NAME type ((7, 1) , (7, 4) ) \n NAME Dog ((7, 6) , (7, 8) ) \n NAME implements ((7, 10) , (7, 19) ) \n NAME Pet ((7, 21) , (7, 23) ) \n LBRACE { ((7, 25) , (7, 25) ) \n NAME name ((8, 3) , (8, 6) ) \n COLON : ((8, 7) , (8, 7) ) \n NAME String ((8, 9) , (8, 14) ) \n BANG ! ((8, 15) , (8, 15) ) \n NAME nickname ((9, 3) , (9, 10) ) \n COLON : ((9, 11) , (9, 11) ) \n NAME String ((9, 13) , (9, 18) ) \n NAME barkVolume ((10, 3) , (10, 12) ) \n COLON : ((10, 13) , (10, 13) ) \n NAME Int ((10, 15) , (10, 17) ) \n NAME doesKnowCommand ((11, 3) , (11, 17) ) \n LPAREN ( ((11, 18) , (11, 18) ) \n NAME dogCommand ((11, 19) , (11, 28) ) \n COLON : ((11, 29) , (11, 29) ) \n NAME DogCommand ((11, 31) , (11, 40) ) \n BANG ! ((11, 41) , (11, 41) ) \n RPAREN ) ((11, 42) , (11, 42) ) \n COLON : ((11, 43) , (11, 43) ) \n NAME Boolean ((11, 45) , (11, 51) ) \n BANG ! ((11, 52) , (11, 52) ) \n NAME isHousetrained ((12, 3) , (12, 16) ) \n LPAREN ( ((12, 17) , (12, 17) ) \n NAME atOtherHomes ((12, 18) , (12, 29) ) \n COLON : ((12, 30) , (12, 30) ) \n NAME Boolean ((12, 32) , (12, 38) ) \n RPAREN ) ((12, 39) , (12, 39) ) \n COLON : ((12, 40) , (12, 40) ) \n NAME Boolean ((12, 42) , (12, 48) ) \n BANG ! ((12, 49) , (12, 49) ) \n NAME owner ((13, 3) , (13, 7) ) \n COLON : ((13, 8) , (13, 8) ) \n NAME Human ((13, 10) , (13, 14) ) \n RBRACE } ((14, 1) , (14, 1) ) \n NAME interface ((16, 1) , (16, 9) ) \n NAME Sentient ((16, 11) , (16, 18) ) \n LBRACE { ((16, 20) , (16, 20) ) \n NAME name ((17, 3) , (17, 6) ) \n COLON : ((17, 7) , (17, 7) ) \n NAME String ((17, 9) , (17, 14) ) \n BANG ! ((17, 15) , (17, 15) ) \n RBRACE } ((18, 1) , (18, 1) ) \n NAME interface ((20, 1) , (20, 9) ) \n NAME Pet ((20, 11) , (20, 13) ) \n LBRACE { ((20, 15) , (20, 15) ) \n NAME name ((21, 3) , (21, 6) ) \n COLON : ((21, 7) , (21, 7) ) \n NAME String ((21, 9) , (21, 14) ) \n BANG ! ((21, 15) , (21, 15) ) \n RBRACE } ((22, 1) , (22, 1) ) \n NAME type ((24, 1) , (24, 4) ) \n NAME Alien ((24, 6) , (24, 10) ) \n NAME implements ((24, 12) , (24, 21) ) \n NAME Sentient ((24, 23) , (24, 30) ) \n LBRACE { ((24, 32) , (24, 32) ) \n NAME name ((25, 3) , (25, 6) ) \n COLON : ((25, 7) , (25, 7) ) \n NAME String ((25, 9) , (25, 14) ) \n BANG ! ((25, 15) , (25, 15) ) \n NAME homePlanet ((26, 3) , (26, 12) ) \n COLON : ((26, 13) , (26, 13) ) \n NAME String ((26, 15) , (26, 20) ) \n RBRACE } ((27, 1) , (27, 1) ) \n NAME type ((29, 1) , (29, 4) ) \n NAME Human ((29, 6) , (29, 10) ) \n NAME implements ((29, 12) , (29, 21) ) \n NAME Sentient ((29, 23) , (29, 30) ) \n LBRACE { ((29, 32) , (29, 32) ) \n NAME name ((30, 3) , (30, 6) ) \n COLON : ((30, 7) , (30, 7) ) \n NAME String ((30, 9) , (30, 14) ) \n BANG ! ((30, 15) , (30, 15) ) \n RBRACE } ((31, 1) , (31, 1) ) \n NAME enum ((33, 1) , (33, 4) ) \n NAME CatCommand ((33, 6) , (33, 15) ) \n LBRACE { ((33, 17) , (33, 17) ) \n NAME JUMP ((33, 19) , (33, 22) ) \n RBRACE } ((33, 24) , (33, 24) ) \n NAME type ((35, 1) , (35, 4) ) \n NAME Cat ((35, 6) , (35, 8) ) \n NAME implements ((35, 10) , (35, 19) ) \n NAME Pet ((35, 21) , (35, 23) ) \n LBRACE { ((35, 25) , (35, 25) ) \n NAME name ((36, 3) , (36, 6) ) \n COLON : ((36, 7) , (36, 7) ) \n NAME String ((36, 9) , (36, 14) ) \n BANG ! ((36, 15) , (36, 15) ) \n NAME nickname ((37, 3) , (37, 10) ) \n COLON : ((37, 11) , (37, 11) ) \n NAME String ((37, 13) , (37, 18) ) \n NAME doesKnowCommand ((38, 3) , (38, 17) ) \n LPAREN ( ((38, 18) , (38, 18) ) \n NAME catCommand ((38, 19) , (38, 28) ) \n COLON : ((38, 29) , (38, 29) ) \n NAME CatCommand ((38, 31) , (38, 40) ) \n BANG ! ((38, 41) , (38, 41) ) \n RPAREN ) ((38, 42) , (38, 42) ) \n COLON : ((38, 43) , (38, 43) ) \n NAME Boolean ((38, 45) , (38, 51) ) \n BANG ! ((38, 52) , (38, 52) ) \n NAME meowVolume ((39, 3) , (39, 12) ) \n COLON : ((39, 13) , (39, 13) ) \n NAME Int ((39, 15) , (39, 17) ) \n RBRACE } ((40, 1) , (40, 1) ) \n NAME union ((42, 1) , (42, 5) ) \n NAME CatOrDog ((42, 7) , (42, 14) ) \n EQUALS = ((42, 16) , (42, 16) ) \n NAME Cat ((42, 18) , (42, 20) ) \n PIPE | ((42, 22) , (42, 22) ) \n NAME Dog ((42, 24) , (42, 26) ) \n NAME union ((43, 1) , (43, 5) ) \n NAME DogOrHuman ((43, 7) , (43, 16) ) \n EQUALS = ((43, 18) , (43, 18) ) \n NAME Dog ((43, 20) , (43, 22) ) \n PIPE | ((43, 24) , (43, 24) ) \n NAME Human ((43, 26) , (43, 30) ) \n NAME union ((44, 1) , (44, 5) ) \n NAME HumanOrAlien ((44, 7) , (44, 18) ) \n EQUALS = ((44, 20) , (44, 20) ) \n NAME Human ((44, 22) , (44, 26) ) \n PIPE | ((44, 28) , (44, 28) ) \n NAME Alien ((44, 30) , (44, 34) ) \n ENDMARKER eof ((45, 1) , (45, 1) ) \n"


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