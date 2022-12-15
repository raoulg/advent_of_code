lines = readlines("data/10.txt")
xs = [1];
[l[1] == 'n' ? push!(xs, xs[end]) : append!(xs, [xs[end], xs[end] + parse(Int, split(l)[2])]) for l in lines];
sum(xs[20:40:end] .* collect(20:40:length(xs)))

screen = [i in j-1:j+1 for (i,j) in zip(repeat(0:39, 6), xs[1:end-1])]
open("out.txt", "w") do f
    for i in 1:40:240
        line = join([p ? '#' : ' ' for p in screen[i:i+39]]) * "\n"
        write(f, line)
    end
end


using GeometryBasics
using AlgebraOfGraphics
using CairoMakie


geometry = [Rect(Vec(i, j), Vec(1, 1)) for i in 0:39 for j in 5:-1:0]
geometry
group = [i in j-1:j+1 ? "dark square" : "light square" for (i,j) in zip(repeat(0:39, 6), xs[1:end-1])]
df = (; geometry, group)

plt = data(df) * visual(Poly) * mapping(:geometry, color = :group)
draw(plt; axis=(aspect=1,))