sum(map(x -> x + (1 - (sign(x))) * 29, [Int(pop!(intersect(Set(s[1:length(s)÷2]), Set(s[1+length(s)÷2:end])))) - 96 for s in readlines(open("data/day3.txt"))]))
sum(map(x -> x + (1 - (sign(x))) * 29, Int.(pop!.(map(x -> intersect(Set.(x)...), Iterators.partition(readlines(open("data/day3.txt")), 3)))) .- 96))
