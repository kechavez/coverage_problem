module CoverageVisual

export visualize_graph

using Compose
using Colors
using Graphs
using LightGraphs
using GraphPlot
using DataStructures

type Agent
    loc::Int64
    cov::Int64
    com::Int64
end

function color_coverage_g(g, agents, mems)
    # Color coverage using color2.
    for a in agents
        # visited = false*Array{Bool,1}(num_vertices(g))
        visited = false*Array{Bool,1}(length(g.vertices))
        q = Queue(Tuple)
        enqueue!(q, (a.loc, a.cov))
        while !isempty(q)
            start,cov = dequeue!(q)
            mems[start] = 2
            if cov != 0
                # for n in in_neighbors(start, g)
                for n in neighbors(g, start)
                    if !visited[n]
                        enqueue!(q, (n,cov-1))
                        visited[n] = true
                    end
                end
            end
        end
    end
    # Color agents using color3.
    for a in agents
        mems[a.loc] = 3
    end
end

function color_coverage_lg(g, agents, mems)
    covered = []
    for a in agents
        covered = union(covered,neighborhood(g, a.loc, a.cov))
        for covered_node in neighborhood(g, a.loc, a.cov)
            mems[covered_node] = 2
        end
    end
    # Color agents using color3.
    for a in agents
        mems[a.loc] = 3
    end
    println("Number of covered nodes (potential function) : "string(length(covered)))
end

function visualize_graph(g, agents, name)
    # color1 -- not covered
    # color2 -- covered
    # color3 -- agent
    nodecolor = [colorant"darksalmon", colorant"gray90",colorant"gray45"]
    membership =  Array{Int64,1}(ones(length(g.vertices)))*1
    
    # color_agent_coverage(g, as, membership)
    color_coverage_lg(g, agents, membership)
    nodefillc = nodecolor[membership]
    # @show membership
    # @show neighborhood(g, 12, 2)
    # @show neighbors(g, 12)
    # @show neighborhood(g, 17, 2)
    # @show neighbors(g, 17)
    # @show neighborhood(g, 25, 1)
    # @show neighbors(g, 25)
    Compose.draw(PDF(name, 25cm, 25cm),
                  # gplot(g,nodefillc=nodefillc))
                  gplot(g,nodelabel=g.vertices,nodefillc=nodefillc))
end

end # module CoverageVisual
