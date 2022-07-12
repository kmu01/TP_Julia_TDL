using CSV
using DataFrames
using MLJ
using DecisionTree
using ScikitLearn.CrossValidation: cross_val_score

dataset = DataFrame(CSV.File("creditcard.csv")) # Size => 284807

# Podemos eliminar la columna "Tiempo", ya que es un factor externo que no vamos a tener en cuenta en nuestro modelo:
dataset = select!(dataset, Not(:Time))

# Removiendo duplicados
dataset = unique(dataset)
data_size = length(dataset[:,1]) # Size => 275663

#Balance
cant_cor = length(dataset[dataset.Class .== 0,:][:,1])
cant_fraud = length(dataset[dataset.Class .== 1,:][:,1])
println("Transacciones totales: ", data_size)
println("Transacciones correctas: ", cant_cor)
println("Transacciones fraudulentas: ", cant_fraud)
println("Porcentaje de transacciones fraudulentas: ", round.(((cant_fraud/cant_cor)*100);digits=2))

#Definimos variales X e Y (dependiente e independiente respectivamente) a partir de las col de nuestro dataset
y, X = unpack(dataset, ==(:Class), rng = 123)
X = Matrix(X)
#Creamos el modelo, en este caso un arbol de decisión
modelo = DecisionTreeClassifier(max_depth = 4)
(Xtrain, Xtest), (ytrain, ytest) = partition((X, y), 0.7, multi = true, rng = 123)
DecisionTree.fit!(modelo, Xtrain, ytrain)
# Lo aplicamos para comenzar a predecir
DecisionTree.predict(modelo, Xtest)
# Obtenemos las probabilidades del modelo
# En el caso del árbol de decisión, esto es la proporción de positivos vs el resto (ya que no es probabilístico)
DecisionTree.predict_proba(modelo, Xtest)
# Testeamos precisión con un test de validacion cruzada.
accuracy = cross_val_score(modelo, Xtest, ytest, cv=3)
println("La precisión de nuestro modelo es: ",accuracy)
