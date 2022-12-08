lines = readlines("data/8.txt");
# part 1
forest = hcat([[parse(Int, n) for n in l] for l in lines]...)';
trees(forest) = CartesianIndices((2:size(forest,1)-1, 2:size(forest,2)-1))
sight(forest, r, c) = map(x -> x .>= forest[r, c], [
                            reverse(forest[r, :][1:c-1]),
                            forest[r, :][c+1:end],
                            reverse(forest[:, c][1:r-1]),
                            forest[:, c][r+1:end]])
visible(forest, r, c) = !all(any.(sight(forest, r, c)))
border = length(forest) - length(trees(forest))
sum([visible(forest, tree[1], tree[2]) for tree in trees(forest)]) + border

# part 2
scenic(v) = isnothing(v) ? 0 : !any(v) ? length(v) : findfirst(v)
maximum([prod(scenic.(sight(forest, tree[1], tree[2]))) for tree in eachindex(forest)])
