# a coordinate struct
struct Coord
    x::Int
    y::Int
end

# if I pass two strings, parse as Int
Coord(x::T, y::T) where T <: AbstractString = Coord(parse(Int, x), parse(Int, y))

# find the (negative) number after x= or y=
reg = r"(x|y)=(-?\d+)"
# If I pass a vector of strings, match the regex and turn into Coors
# take the second part, because I split at ":" later on
Coord(parsed) = Coord([x[2] for x in collect(eachmatch(reg, parsed))]...)

# define how to subtract two Coord
Base.:-(c1::Coord, c2::Coord) = Coord(c1.x - c2.x, c1.y-c2.y)
# and calculate manhattan distance
manhattan(S::Coord, B::Coord) = sum(abs.([S.x-B.x, S.y-B.y]))

# A cover is a thing that has a Sensor, a Beacon and a distance
# the distance is calculated when just a S and B are passed
struct Cover
    S::Coord
    B::Coord
    d::Int
    Cover(S, B) = new(S, B, manhattan(S, B))
end

# if a row number is passed to a Cover,
# calculate how much residu is left from the max distance
# if bigger than 0, calculate how much is covered at that exact row
# or nothing
function covered(Cover, row)
    δy = abs(Cover.S.y - row)
    residu = Cover.d - δy
    if residu >= 0
        startstop = [Cover.S.x - residu, Cover.S.x + residu]
        return range(start=startstop[1], stop=startstop[2])
    end
    nothing
end



# given lines of text, split them, and build S and B Coord from it
# from those pairs, create covers
function build_covers(lines)
    covers = [map(Coord, split(line, ":")) for line in lines]
    [Cover(c...) for c in covers]
end

# this calculates the min and max of a collection of ranges
maxrange(ranges) = minimum(minimum.(ranges)):maximum(maximum.(ranges))

# for a row, find the ranges from all covers
# remove the empty ranges
function check_row(covers, row)
    ranges = [covered(c, row) for c in covers]
    filter(!isnothing, ranges)
end

# there might be beacons in the row
count_beacons(covers, row) = unique([c.B for c in filter(c -> c.B.y == row, covers)])

lines = readlines("data/15.txt")
covers = build_covers(lines)
row = 2000000
@time k = count_beacons(covers, row)
r = maxrange(check_row(covers, row))
length(r) - length(k)



function check_rowrange(m, n)
    for row in m:n
        if row % 50000== 0
            @info "row # $row"
        end
        ranges = sort(check_row(covers, row))
        big = last(ranges[1])
        for i in 2:lastindex(ranges)
            r = ranges[i]
            if last(r) > 4000000
                break
            end
            if big > last(r)
                continue
            elseif big >= first(r) -1
                big = last(r)
            else
                @info "Row: $row, big: $big, r: $r"
                @info "$(row + (big+1) * 4000000)"
                return nothing
            end
        end
    end
end

lines = readlines("data/15.txt")
covers = build_covers(lines)
@time check_rowrange(0, 4000000)

function get_c(c, row)
    res = c.d - abs(c.S.y - row)
    if res > 0
        min = maximum([c.S.x - res, 0]) 
        max = minimum([c.S.x + res, 4000000])
        return min, max
    end
    nothing
end
make_d(c, n, m) = Dict(r => get_c(c, r) for r in n:m if !isnothing(get_c(c,r)))
@time cdict = [make_d(c, 0, 4000000) for c in covers]

fast_range(cdict, row) = sort([d[row] for d in cdict if row in keys(d)])
ranges = fast_range(cdict, 0)

function fast_rowrange(n, m)
    cdict = [make_d(c, n, m) for c in covers]
    for row in n:m
        if row % 50000== 0
            @info "row # $row"
        end
        ranges = fast_range(cdict, row)
        big = last(ranges[1])
        for i in 2:lastindex(ranges)
            r = ranges[i]
            if last(r) > 4000000
                break
            end
            if big > last(r)
                continue
            elseif big >= first(r) -1
                big = last(r)
            else
                @info "Row: $row, big: $big, r: $r"
                @info "$(row + (big+1) * 4000000)"
                return nothing
            end
        end
    end
end

@time fast_rowrange(0, 4000000)