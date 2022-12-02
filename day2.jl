@enum Round Rock=1 Paper=2 Scissors=3

decode = Dict(
    "A" => Rock, "B" => Paper, "C" => Scissors,
    "X" => Rock, "Y" => Paper, "Z" => Scissors,
    )


function Base.:>(x::Round, y::Round)
    if (x == Rock) & (y == Scissors)
        true
    elseif (x == Scissors) & (y == Rock)
        false
    else
        Int(x) > Int(y)
    end
end

Base.:<(x::Round, y::Round) = y > x


function score(x::Round, y::Round)
    if x == y
        return Int(y) + 3
    elseif x < y
        return Int(y) + 6
    else
        return Int(y)
    end
end

function parse_score(filename)
    total = 0
    for line in readlines(open(filename))
        x, y = map(x -> decode[x], split(line, " "))
        total += score(x, y)
    end
    total
end

parse_score("day2.txt")

function figure_out(x::Round, f)
    for y in instances(Round)
        if f(x, y)
            return y
        end
    end
end

decode2 = Dict(
    "A" => Rock, "B" => Paper, "C" => Scissors,
    "X" => >, "Y" => ==, "Z" => <,
    )
function parse_score2(filename)
    total = 0
    for line in readlines(open(filename))
        x, f = map(x -> decode2[x], split(line, " "))
        y = figure_out(x, f)
        total += score(x, y)
    end
    total
end

parse_score2("day2.txt")

