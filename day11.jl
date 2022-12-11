file = "data/11.txt"

macro inspect(op, c)
    op = Symbol(eval(op))
    c = eval(c)
    c_int = tryparse(Int, c)
    !isnothing(c_int) ? c = c_int : c = Symbol(c)
    quote 
        function inspect(old)
            ($(esc(op))(old, $c))
        end
    end
end

macro throw_to(vals)
    v , y, n = eval(vals)
    quote 
        function throw_to(worry)
            worry % $v == 0 ? $y : $n
        end
    end
end

function parse_monkey(monkey)
    items = parse.(Int, split(split(monkey[2], ":")[2], ","))
    op, c = split(monkey[3])[end-1:end]
    f1 = eval(quote @inspect $op $c end)
    vals = map(x -> parse(Int, split(x)[end]), monkey[4:6])
    f2 = eval(quote @throw_to $vals end)
    items, f1, f2, vals[1]
end

mutable struct Monkey
    items::Vector{Int64}
    inspect
    throwto
    v::Int
    n::Int
end

function build_monkeylist(file)
    monkeys = split(read(file, String), "\n\n")
    monkeylist = []
    for monkey in monkeys
        m = split(monkey, "\n")
        println(m)
        M = Monkey(parse_monkey(m)..., 0 )
        push!(monkeylist, M)
    end
    monkeylist
end

function monkeybusiness(monkeylist, n, N)
    for _ in 1:n
        for monkey in monkeylist
            monkey.n += length(monkey.items)
            for worry in monkey.inspect.(monkey.items)
                worry = worry % N
                idx = monkey.throwto.(worry)
                append!(monkeylist[idx+1].items, worry)
                monkey.items = []
            end
        end
    end
    [x.n for x in sort(monkeylist, by = x -> x.n, rev=true)]
end


monkeylist = build_monkeylist(file);
max_divide = 1
for m in monkeylist
    max_divide *= m.v
end

@time b = monkeybusiness(monkeylist, 10000, max_divide)
prod(b[1:2])
    
