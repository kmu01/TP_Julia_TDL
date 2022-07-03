
using LinearAlgebra
using Distributed

using CSV
using DataFrames


function normalizarVelocidades(bloque)
    
    auxiliar = []
    for i in 1:nrow(bloque)
        normalizada =sqrt(bloque[i,"vx"]^2+bloque[i,"vy"]^2+bloque[i,"vz"]^2)
        push!(auxiliar,normalizada)
    end
    return auxiliar
end
println("Utilizando: ",Threads.nthreads(), " Threads")
println("-------[Cargando Dataset]-------")

#Carga del dataset completo
df = CSV.read("datasets/cluster_estrellas/c_0000.csv",select=["vx","vy","vz","id"], DataFrame)

#Division del dataset en bloques
bloques = []
limit =convert(Int,nrow(df) / Threads.nthreads())

for i in 0:(Threads.nthreads()-1)
    push!(bloques, df[1+i*limit:limit*(i+1),["vx","vy","vz","id"]])
    println("*Tamaño del bloque[",i+1,"]:",size(bloques[i+1]))
end


r1 =Threads.@spawn @time normalizarVelocidades(bloques[1])
r2 =Threads.@spawn @time normalizarVelocidades(bloques[2])

 fetch(r1)
 fetch(r2)













