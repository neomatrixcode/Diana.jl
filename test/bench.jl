

const resolvers = Dict(
    "Query"=>Dict(
        "neomatrix" => (root,args,ctx,info)->(return Dict("nombre"=>"josue","edad"=>26)),
        "persona" => (root,args,ctx,info)->(return Dict("nombre"=>"Diana","edad"=>25))
    ),
    "Persona"=>Dict(
        "edad" => (root,args,ctx,info)->(return root["edad"])
    )
)


@btime resolvers["Query"]["neomatrix"](1,2,3,4)
#  1.050 μs (17 allocations: 1.98 KiB)
#Dict{String,Any} with 2 entries:
#  "edad"   => 26
#  "nombre" => "josue"

const resolvers2 = (
           Query = (
               neomatrix = (root, args, ctx, info) -> (nombre = "josue", edad = 26),
               persona = (root, args, ctx, info) -> (nombre = "Diana", edad = 25)
           ),
           Persona = (
               edad = (root, args, ctx, info) -> root.edad,
           )
       )

@btime resolvers2.Query.neomatrix(1,2,3,4)
#  1.199 ns (0 allocations: 0 bytes)
#(nombre = "josue", edad = 26)