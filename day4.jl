lines = [split.(split(l, ","), "-") for l in readlines(open("data/day4.txt"))]
start_end = [map(x -> parse.(Int64, x), z) for z in lines]
container(b) = (b[1] <= b[3] && b[2] >= b[4]) || (b[3] <= b[1] && b[4] >= b[2])
sum([container(vcat(a...)) for a in start_end])

overlap(a) = length(intersect(Set(range(a[1], a[2])), Set(range(a[3], a[4])))) > 0
sum([overlap(vcat(a...)) for a in start_end])
