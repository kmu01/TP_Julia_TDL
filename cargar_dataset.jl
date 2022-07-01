using CSV
using DataFrames
using Statistics
#Cargar el contenido del archivo del dataset .csv
 df = CSV.read("datasets/cluster_estrellas/c_0000.csv", DataFrame)
# tamaño del dataset cargado
println(size(df))

#extraer las masas e ids de las estrellas
columnas = ["id","m"]
 masas = df[:,columnas] # [filas,columnas] 
#println("masas:",masas)


columnas = ["id","vx","vy","vz"]
 velocidades = df[:,columnas]
#println("velocidades:",velocidades)

println("Ordenando masas")
@time sort!(masas)
println(masas)#1.5625001e-5

