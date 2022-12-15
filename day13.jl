function compare(left::Int, right::Int)
    left == right ? nothing : left < right
end

function compare(left::Vector, right::Vector)
    for (l, r) in zip(left, right)
        decide = compare(l, r)
        if decide isa Bool
            return decide
        end
    end
    return compare(length(left), length(right))
end

compare(l::Vector, r::Int) = compare(l, [r])
compare(l::Int, r::Vector) = compare([l], r)

lines = split(read("data/13.txt", String), "\n\n");
pairs = [map(eval ∘ Meta.parse, split(l)) for l in lines];
sum([i for (i,p) in enumerate(pairs) if compare(p...)])

dividers = [[[2]], [[6]]]
all = append!(vcat(pairs...), dividers)
sorted = sort!(all, lt=compare)
prod(indexin(dividers, sorted))

x = "[1,2,3]"

x[1] == '['