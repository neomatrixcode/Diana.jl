
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
  if e isa Diana.GraphQLError
    @test string(e) ==  "Diana.GraphQLError(\"{\\\"errors\\\":[{\\\"locations\\\": [{\\\"column\\\": 1,\\\"line\\\": 2}],\\\"message\\\": \\\"Syntax Error GraphQL request (2:1) Unexpected character % \\\"}]}\")"
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
  @test string(e) == "Diana.GraphQLError(\"{\\\"errors\\\":[{\\\"locations\\\": [{\\\"column\\\": 11,\\\"line\\\": 6}],\\\"message\\\": \\\"Syntax Error GraphQL request (11:6) Expected NAME, found } \\\"}]}\")"
end


@test "$(Parse(
"""
{
  field(arg: null)
  field
}
"""))" == "\n\e[33m < \e[37mNode :: Document ,definitions : Any[\n\e[33m < \e[37mNode :: OperationDefinition ,operation : \e[92mquery\e[37m ,selectionSet : \n\e[33m < \e[37mNode :: SelectionSet ,selections : Diana.Field[\n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mfield\e[37m\e[33m > \e[37m ,arguments : Diana.Argument[\n\e[33m < \e[37mNode :: Argument ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92marg\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: NullValue\e[33m > \e[37m)\e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mfield\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m"


@test "$(Parse(
"""
{
  nearestThing(location: { lat: -53.211, lon: 12.43 })
}
"""))" == "\n\e[33m < \e[37mNode :: Document ,definitions : Any[\n\e[33m < \e[37mNode :: OperationDefinition ,operation : \e[92mquery\e[37m ,selectionSet : \n\e[33m < \e[37mNode :: SelectionSet ,selections : Diana.Field[\n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mnearestThing\e[37m\e[33m > \e[37m ,arguments : Diana.Argument[\n\e[33m < \e[37mNode :: Argument ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mlocation\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: Object ,fields : Any[\n\e[33m < \e[37mNode :: Object_Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mlat\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: FloatValue ,value : \e[92m-53.211\e[37m\e[33m > \e[37m)\e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: Object_Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mlon\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: FloatValue ,value : \e[92m12.43\e[37m\e[33m > \e[37m)\e[37m\e[33m > \e[37m]\e[33m > \e[37m)\e[37m\e[33m > \e[37m]\e[33m > \e[37m]\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m"


@test "$(Parse(
"""
query getZuckProfile(\$devicePicSize: Int) {
  user(id: 4) {
    id
    name
    profilePic(size: \$devicePicSize)
  }
}
"""))" == "\n\e[33m < \e[37mNode :: Document ,definitions : Any[\n\e[33m < \e[37mNode :: OperationDefinition ,operation : \e[92mquery\e[37m ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mgetZuckProfile\e[37m\e[33m > \e[37m ,variableDefinitions : Diana.VariableDefinition[\n\e[33m < \e[37mNode :: VariableDefinition ,variable : \n\e[33m < \e[37mNode :: Variable ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mdevicePicSize\e[37m\e[33m > \e[37m\e[33m > \e[37m ,tipe : (\":\", \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mInt\e[37m\e[33m > \e[37m\e[33m > \e[37m)\e[33m > \e[37m] ,selectionSet : \n\e[33m < \e[37mNode :: SelectionSet ,selections : Diana.Field[\n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92muser\e[37m\e[33m > \e[37m ,arguments : Diana.Argument[\n\e[33m < \e[37mNode :: Argument ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mid\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: IntValue ,value : \e[92m4\e[37m\e[33m > \e[37m)\e[37m\e[33m > \e[37m] ,selectionSet : \n\e[33m < \e[37mNode :: SelectionSet ,selections : Diana.Field[\n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mid\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mname\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mprofilePic\e[37m\e[33m > \e[37m ,arguments : Diana.Argument[\n\e[33m < \e[37mNode :: Argument ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92msize\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: Variable ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mdevicePicSize\e[37m\e[33m > \e[37m\e[33m > \e[37m)\e[37m\e[33m > \e[37m]\e[33m > \e[37m]\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m"

@test "$(Parse(
"""
schema {
  query: MyQueryRootType
  mutation: MyMutationRootType
}

type MyQueryRootType {
  someField: String
}

type MyMutationRootType {
  setSomeField(to: String): String
}
"""))" == "\n\e[33m < \e[37mNode :: Document ,definitions : Any[\n\e[33m < \e[37mNode :: SchemaDefinition ,operationTypes : Diana.OperationTypeDefinition[\n\e[33m < \e[37mNode :: OperationTypeDefinition ,operation : \e[92mquery\e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mMyQueryRootType\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: OperationTypeDefinition ,operation : \e[92mmutation\e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mMyMutationRootType\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mMyQueryRootType\e[37m\e[33m > \e[37m ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92msomeField\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: ObjectTypeDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mMyMutationRootType\e[37m\e[33m > \e[37m ,fields : Any[\n\e[33m < \e[37mNode :: FieldDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92msetSomeField\e[37m\e[33m > \e[37m ,arguments : Diana.InputValueDefinition[\n\e[33m < \e[37mNode :: InputValueDefinition ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mto\e[37m\e[33m > \e[37m ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m] ,tipe : \n\e[33m < \e[37mNode :: NamedType ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mString\e[37m\e[33m > \e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m]\e[33m > \e[37m"


@test "$(Parse(
"""
{
  foo @skip(if: true)
  bar
  foo
}
"""))" == "\n\e[33m < \e[37mNode :: Document ,definitions : Any[\n\e[33m < \e[37mNode :: OperationDefinition ,operation : \e[92mquery\e[37m ,selectionSet : \n\e[33m < \e[37mNode :: SelectionSet ,selections : Diana.Field[\n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mfoo\e[37m\e[33m > \e[37m ,directives : Any[\n\e[33m < \e[37mNode :: Directive ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mskip\e[37m\e[33m > \e[37m ,arguments : Diana.Argument[\n\e[33m < \e[37mNode :: Argument ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mif\e[37m\e[33m > \e[37m ,value : \e[92m(\":\", \n\e[33m < \e[37mNode :: BooleanValue ,value : \e[92mtrue\e[37m\e[33m > \e[37m)\e[37m\e[33m > \e[37m]\e[33m > \e[37m]\e[33m > \e[37m, \n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mbar\e[37m\e[33m > \e[37m\e[33m > \e[37m, \n\e[33m < \e[37mNode :: Field ,name : \n\e[33m < \e[37mNode :: Name ,value : \e[92mfoo\e[37m\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m\e[33m > \e[37m]\e[33m > \e[37m"

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


