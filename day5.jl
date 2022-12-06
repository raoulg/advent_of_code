function get_stacks(schema)
    z = split(schema, "\n")
    stacks = [[] for _ in 1:length(split(z[end]))]
    levels = [l[2:4:end] for l in z[1:end-1]]
    for items in levels
        for (i, l) in enumerate(items)
            !isspace(l) && push!(stacks[i], l)
        end
    end
    stacks
end

parse_moves(moves) = [filter(x -> contains(x, r"\d+"), z) for z in split.(split(moves, "\n"))]

function rearrange!(stacks, move, cratemover = 9000)
    n, f, t = parse.(Int, move)
    tomove = [popfirst!(stacks[f]) for _ in 1:n]
    cratemover == 9001 ? reverse!(tomove) : nothing
    for crate in tomove
        pushfirst!(stacks[t], crate)
    end
end


function run(filename, cratemover)
    schema, moves_string = split(rstrip(read(open(filename), String)), "\n\n")
    stacks = get_stacks(schema)
    moves = parse_moves(moves_string)
    for move in moves
        rearrange!(stacks, move, cratemover)
    end
    join(popfirst!.(stacks))
end

filename = "data/5.txt"
run(filename, 9000)
run(filename, 9001)
