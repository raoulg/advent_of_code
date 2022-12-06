function get_stars(f)
    line = readline(f)
    isempty(line) ? stars = 0 : stars = parse(Int64, line)
    stars, line
end

function gather(filename) 
    open(filename) do f
        elve_stars = []
        while ! eof(f)
            stars, line = get_stars(f)
            while (! isempty(line))
                star, line = get_stars(f)
                stars += star
            end
            push!(elve_stars, stars)
        end
        elve_stars
    end
end

stars = gather("data/day1.txt")
elve_stars = sort(stars, rev=true)
sum(elve_stars[1:3])
