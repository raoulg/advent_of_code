filename = "data/6.txt"
signal(n) = [findfirst([(allunique(l[i:i+n-1])) for i in 1:length(l)-n-1]) for l in readlines(open(filename))] .+ (n-1)
signal(4)
signal(14)
