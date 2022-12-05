function split_input(filename)
    lines = readlines(open(filename))
    idx = findfirst(isempty, lines)
    lines[1:idx-2], lines[idx+1:end]
end

function parse_schema(schema)
    levels = []
    for level in schema
        push!(levels, [c  for (i, c) in enumerate(level) if ((i-2) % 4 == 0)])
    end
    n = (length(first(schema))+1)÷4
    stacks = [[] for _ in 1:n]
    stacks, levels
end

function build_stacks(schema_string)
    stacks, levels = parse_schema(schema_string)
    for crates in levels
        for (i, crate) in enumerate(crates)
            !isspace(crate) ? push!(stacks[i], crate) : nothing
        end
    end
    stacks
end

parse_moves(moves) = map(x -> parse.(Int64, [x[2], x[4], x[6]]), split.(moves))

function rearrange!(stacks, move, cratemover = 9000)
    n, f, t = move
    tomove = [popfirst!(stacks[f]) for _ in 1:n]
    cratemover == 9001 ? reverse!(tomove) : nothing
    for crate in tomove
        pushfirst!(stacks[t], crate)
    end
end

function run(filename, cratemover)
    schema_strings, move_strings = split_input(filename)
    stacks = build_stacks(schema_strings)
    moves = parse_moves(move_strings)
    for move in moves
        rearrange!(stacks, move, cratemover)
    end
    join(popfirst!.(stacks))
end

filename = "data/5.txt"
run(filename, 9000)
run(filename, 9001)

