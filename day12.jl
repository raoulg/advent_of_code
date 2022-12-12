using Graphs
onestep(x, y) = x+1 >= y
swap(x) = x == 'S' ? 'a' : x == 'E' ? 'z' : x

function surround(i, m, N) 
    area = []
    if i % m != 0 push!(area, i+1) end
    if i % m != 1 push!(area, i-1) end
    if i + m <= N push!(area, i+m) end
    if i - m > 0 push!(area, i-m) end
    area
end

function build_matrix(matrix)
    lines = rsplit(matrix)
    nodes = replace(matrix, r"\n" => "")
    m = length(first(lines))
    N = length(nodes)
    g = SimpleDiGraph(N)
    for i in Base.OneTo(N)
        area = surround(i, m, N)
        v1 = swap(nodes[i])
        for j in area
            v2 = swap(nodes[j])
            if onestep(v1, v2)
                add_edge!(g, i, j)
            end
        end
    end
    g
end

# part I
matrix = read("data/12.txt", String);
nodes = replace(matrix, r"\n" => "");
g = build_matrix(matrix)
S1 = findfirst('S', nodes)
E = findfirst('E', nodes)
@time A = a_star(g, S1, E);
length(A)

# Part II
function optimal(g, nodes, E)
    best = Inf
    route = nothing
    for start in findall('a', nodes)
        A = a_star(g, start, E)
        if length(A) < best && ! isempty(A)
            best = length(A)
            route = A
        end
    end
    return best, route
end
@time best, route = optimal(g, nodes, E);
best

using CairoMakie
function plot_vlist(vmap, g, shape)
    n, m = shape
    z = [i in vmap for i in vertices(g)]
    z = reverse(reverse(reshape(z, (n,m))), dims=1)
    heatmap(z)
end

vmap = [e.src for e in A]
plot_vlist(vmap, g, (161,41))
