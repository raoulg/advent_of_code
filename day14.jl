using Plots

function parse_coords(coord, rocks)
    rocks[tuple(first(coord)...)] = 1
    for i in 2:lastindex(coord)
        c1 = coord[i-1]
        c2 = coord[i]
        δ = findfirst(c1 .!= c2) # where do the coords differ?
        δ == 2 ? i = 1 : i = 2 # if on the second place, use the other, and vice versa
        x = sort([c1[δ], c2[δ]]) # make sure order is right for range to work
        r1 = collect(range(x[1], x[2])) # first range
        r2 = fill(c1[i], length(r1)) # other range
        δ == 2 ? n = zip(r2, r1) : n = zip(r1, r2) # zip them in correct order
        for p in collect(n) # add to rocks
            rocks[p] = 1
        end
    end
    rocks
end

mutable struct Cave
    rocks::Dict
    maximum::Int
    sand::Tuple
    rest::Bool
    abyss::Bool
    i::Int
end

function check_abyss!(Cave)
    if Cave.sand[2] > Cave.maximum
        Cave.rocks[Cave.sand] = 1
        Cave.abyss = true
    end
end

function move!(Cave, checkabyss)
    if checkabyss 
        check_abyss!(Cave)
    end

    if Cave.abyss
        return Cave
    end

    if Cave.sand[2] == Cave.maximum + 1
        Cave.rocks[Cave.sand] = 1
    end

    if haskey(Cave.rocks, Cave.sand)
        Cave.rest = true
        return Cave
    end

    if !haskey(Cave.rocks, Cave.sand .+ (0,1))
        Cave.sand = Cave.sand .+ (0, 1)
    elseif !haskey(Cave.rocks, Cave.sand .+ (-1,1))
        Cave.sand = Cave.sand .+ (-1,1)
    elseif !haskey(Cave.rocks, Cave.sand .+ (1,1))
        Cave.sand = Cave.sand .+ (1,1)
    else
        Cave.rocks[Cave.sand] = 1
    end
    Cave
end

function produce!(Cave, checkabyss)
    Cave.sand = (500, 0)
    Cave.rest = false
    while ! Cave.rest && ! Cave.abyss
        move!(Cave, checkabyss)
    end
    Cave.i += 1
end

function scan(lines)
    coords = [[parse.(Int, split(x, ",")) for x in split(line, "->")] for line in lines]
    rocks = Dict{Tuple{Int64, Int64}, Int64}()
    for c in coords
        rocks = parse_coords(c, rocks)
    end
    abyss = maximum([x[2] for x in keys(rocks)])
    Cave(rocks, abyss, (0,0), false, false, 0)
end


function plot_cave(cave)
    x, y = [], []
    for (a,b) in keys(cave.rocks)
        append!(x, a)
        append!(y, b)
    end
    scatter(x, y)
end

# part 1
lines = readlines("data/14.txt")

function search_abyss(lines)
    cave = scan(lines);
    while ! cave.abyss
        produce!(cave, true)
    end
    cave
end

@time cave = search_abyss(lines)
plot_cave(cave)
cave.i - 1

# part 2
function simulate(lines)
    cave = scan(lines);
    produce!(cave, false)

    while cave.sand != (500,0)
        if cave.i % 1000 == 0
            @info "currently $(cave.i) and $(cave.sand)"
        end
        produce!(cave, false)
    end
    cave
end

@time cave = simulate(lines)
plot_cave(cave)
cave.i



