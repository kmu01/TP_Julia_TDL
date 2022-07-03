
using Distributed
using LinearAlgebra
using CSV
using DataFrames
#recibe un dataframe de vectores velocidades (vx,vy,vz) y devuelve el promedio de cada fila
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


#Cargar el contenido del archivo del dataset .csv
df = CSV.read("datasets/cluster_estrellas/c_0000.csv",select=["vx","vy","vz","id"], DataFrame)
bloqueVectorVelocidades = df[:,["vx","vy","vz"]]

println("Tiempo en normalizar velocidades Single-Thread: ")
@time moduloVelocidades = normalizarVelocidades(bloqueVectorVelocidades)







