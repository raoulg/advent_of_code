lines = split.(readlines("data/9.txt"))

Moves = (L=(0,-1), R=(0,1), U=(1,0), D=(-1,0))
adjust(δ) = any(in([-2, 2]).(δ))  ? sign.(δ) .* (1,1) : (0,0)
follow(h::Tuple, t::Tuple) = adjust(h .- t) .+ t
add!(visited, tail::Tuple) = tail ∉ visited && push!(visited, tail)

function simulate(lines, Head, Tail, visited)
    for line in lines
        m, c= Symbol(line[1]), parse(Int, line[2])
        for _ in 1:c
            Head = Head .+ Moves[m]
            Tail = follow(Head, Tail)
            add!(visited, Tail)
        end
    end
    length(visited)
end

function follow(Head::Tuple, Tail::Vector)
    Tail[1] = follow(Head, Tail[1])
    for i in 1:length(Tail)-1
        Tail[i+1] = follow(Tail[i], Tail[i+1])
    end
    Tail
end
add!(visited, tail::Vector) = add!(visited, tail[end])

simulate(lines, (0,0), (0,0), [])
simulate(lines, (0,0), [(0,0) for _ in 1:9], [])

