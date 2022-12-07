# Tree data structures

struct Leave{T<: AbstractString}
    name::T
    size::Int
end

mutable struct Node
    name::String
    parent::Union{Node, Nothing}
    children::Array{Node}
    files::Array{Leave}
    size::Int
end

Node(name::T) where T <: AbstractString = Node(name, nothing, [], [], 0)

struct Tree
    root::Node
end

"""
determine if we are entering commands or reading output
"""
get_state(l) = occursin(r"^\$", l) ? :command : :output

"""
update the size of the current node, plus of its parent
"""
function update_size(n::Node, size)
    n.size += size
    if !isnothing(n.parent)
        update_size(n.parent, size)
    end
end

"""
parses every output line l
An output line is either a new dir to be added to the current nodes children,
or its a file, to be added as a leave

The size of the current node (and its parents) will be updated
"""
function parse_output!(l, node::Node)
    if occursin(r"^dir", l)
        name = split(l)[end]
        # check if the dir isnt already visited
        if name ∉ [n.name for n in node.children]
            new_node = Node(name, node, [], [], 0)
            push!(node.children, new_node)
        end
    elseif occursin(r"^\d", l)
        size, name = split(l)
        size = parse(Int, size)
        leave = Leave(name, size)
        push!(node.files, leave)
        update_size(node, size)
    end
end

"""
Builds the tree.
Assumes the lines start with root.
We are parsing either commands or outputs
In the case of commands, this is either moving up a node,
or changing the current node

The output is handled by parse_output
"""
function build_tree(lines)
    occursin(r"^\$ cd /", first(lines)) ? tree = Tree(Node("/")) : error("First line should be root")
    current_node = tree.root
    for l in lines[2:end]
        state = get_state(l)
        if state == :command
            if occursin(r"cd", l)
                goto = split(l)[end]
                if goto == ".."
                    current_node = current_node.parent
                else
                    idx = indexin([goto], [c.name for c in current_node.children])[1]
                    current_node = current_node.children[idx]
                end
            end
        elseif state == :output
            parse_output!(l, current_node)
        end
    end
    tree
end

function walk_tree(node, limit, total, op)
    if op(node.size, limit)
        total += node.size
        push!(options, node)
    end
    for c in node.children 
            total = walk_tree(c, limit, total, op)
    end
    total
end


lines = readlines("data/7.txt")
tree = build_tree(lines);
options = []
walk_tree(tree.root, 1e5, 0, <=)

unused = 7e7 - tree.root.size
limit = 3e7 - unused
options = []
walk_tree(tree.root, limit, 0, >=)
sort!(options, by= x->x.size);
options[1].size
