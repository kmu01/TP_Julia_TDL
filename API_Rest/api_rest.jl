import Pkg

Pkg.add("HTTP")
Pkg.add("JSON3")
Pkg.add("Primes")

using HTTP
using JSON3
using Primes

function lucas(n)
  if n == 1 return 2 end
  if n == 2 return 1 end
  prev = UInt128(1)
  pprev = UInt128(2)
  for i=3:n
    curr = prev + pprev 
    pprev = prev
    prev = curr
  end
  return prev
end

function next_prime(n)
  return Primes.prime(n)
end

function fibonacci(n)
  if n == 1 return 1 end
  if n == 2 return 1 end
  prev = UInt128(1)
  pprev = UInt128(1)
  for i=3:n
    curr = prev + pprev 
    pprev = prev
    prev = curr
  end
  return prev
end

function sqr(n)
  return n*n
end

function get_num_from_url(url)
  return HTTP.URIs.splitpath(url)[3]
end

function get_series_from_url(url)
  return HTTP.URIs.splitpath(url)[2]
end

function manageRequest(req::HTTP.Request)
  url = req.target
  number = get_num_from_url(url)
  series = get_series_from_url(url)
  
  if series == "fibonacci"
    response = fibonacci(parse(Int, number))
  end
  if series == "prime"
    response = next_prime(parse(Int, number))
  end
  if series == "sqr"
    response = sqr(parse(Int, number))
  end
  if series == "lucas"
    response = lucas(parse(Int, number))
  end
  
  return HTTP.Response(200, JSON3.write(response))
end

const API_ROUTER = HTTP.Router()
HTTP.@register(API_ROUTER, "GET", "/api/fibonacci/*", manageRequest)
HTTP.@register(API_ROUTER, "GET", "/api/prime/*", manageRequest)
HTTP.@register(API_ROUTER, "GET", "/api/sqr/*", manageRequest)
HTTP.@register(API_ROUTER, "GET", "/api/lucas/*", manageRequest)

println("API up in localhost at port 8080...")
HTTP.serve(API_ROUTER, "127.0.0.1", 8080)