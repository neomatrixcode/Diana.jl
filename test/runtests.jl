using Diana
using Base.Test


Query = """
{
  neomatrix{
    nombre
    linkedin
  }
} 
"""   

Query2 = """
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

@test query("https://neomatrix.herokuapp.com/graphql",Query) == "{\"data\":{\"neomatrix\":{\"nombre\":\"Acevedo Maldonado Josue\",\"linkedin\":\"https://www.linkedin.com/in/acevedo-maldonado-josue/\"}}}"

# @test query("https://api.github.com/graphql",Query2,auth,vars) == "{\"data\":{\"viewer\":{\"name\":\"neomatrix\",\"repositories\":{\"nodes\":[{\"name\":\"bombs\"},{\"name\":\"prueba\"},{\"name\":\"Diana.jl\"}]}}}}"

