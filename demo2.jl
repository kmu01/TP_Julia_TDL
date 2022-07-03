using Distributed

println("Utilizando :",Threads.nthreads()," Hilos")

vector = zeros(12)
Threads.@threads for i = 1:12
    vector[i] = Threads.threadid()
end

println(vector)
