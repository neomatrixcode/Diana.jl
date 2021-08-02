using Diana
using BenchmarkTools

schema = Dict(
 "query" => "Query"

,"Query"=> Dict(
    "persona"=>Dict("tipo"=>"Persona")
   ,"neomatrix"=>Dict("tipo"=>"Persona")
   )

,"Persona" => Dict(
    "edad"=>Dict("tipo"=>"Int")
   ,"nombre"=>Dict("tipo"=>"String")
  )

)


 resolvers=Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(return Dict("nombre"=>"josue","edad"=>26))
        ,"persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>25))
    )
    ,"Persona"=>Dict(
      "edad" => (root,args,ctx,info)->(return root["edad"])
    )
)

my_schema = Schema(schema, resolvers)


query= """
{
  neomatrix{
    nombre
  }
}
"""

@btime my_schema.execute(query)

# Record
# $ julia benchmark.jl   ## 20/07/2021
# 532.800 μs (1018 allocations: 56.52 KiB)