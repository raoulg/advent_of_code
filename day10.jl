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
