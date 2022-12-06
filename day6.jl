filename = "data/6.txt"
signal(n) = [findfirst([(allunique(l[i:i+n-1])) for i ∈ 1:length(l)-n-1]) for l ∈ readlines(filename)] .+ (n-1)
signal(4)
signal(14)
