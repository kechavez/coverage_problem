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
    nodecolor = [colorant"darksalmon", colorant"lightgreen",colorant"gray45"]
    # nodecolor = [colorant"gray90",colorant"darksalmon", colorant"gray45"]
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
    # nlist = Array(Vector{Int}, 4) # 4 shells
    # nlist[1] = 1:25 
    # nlist[2] = 26:50
    # nlist[3] = 51:75
    # nlist[4] = 76:100
    # locs_x, locs_y = shell_layout(g, rand(ne(g)))
    locs_x, locs_y = spring_layout(g)

locs_x = [-0.982344,-0.593226,-0.46841,0.0998962,0.994277,0.0453519,0.566664,0.677151,0.0478354,0.258459,0.122338,0.817768,0.20789,0.477805,0.000135829,0.330554,-0.585516,0.299633,-0.699893,0.877731,-0.213842,0.377236,0.230362,0.395231,-0.7527,0.53271,-0.529818,0.426218,0.802987,0.218984,0.787141,0.488446,-0.340476,0.342789,-0.558339,0.0251904,0.894743,0.198338,0.389764,-0.790287,0.520309,-0.627522,0.475971,0.425575,-0.112057,0.282197,0.0792741,-0.499759,-0.630092,0.00946592,0.338598,0.310062,0.165118,0.545639,0.853288,0.207404,0.100208,-0.0651516,-1.0,0.0156267,-0.141871,1.0,-0.576884,0.609881,0.0883375,0.771173,0.256381,0.0515315,0.306366,0.499301,-0.42563,0.317362,0.134752,-0.524415,-0.699867,-0.0103039,0.0250713,0.732189,0.746555,-0.64823,-0.286642,0.842339,0.0877249,-0.210614,0.148156,0.183866,-0.33714,0.173159,0.763372,0.455419,0.527356,0.726887,0.124569,0.826579,-0.0295234,0.0893384,0.693271,0.913273,0.703204,0.265378]
locs_y = [0.0281232,0.508211,0.294969,0.601553,0.499681,0.747415,-0.762094,-0.938199,-0.0289591,-0.403412,0.865877,-0.885914,-0.607061,0.182773,0.11168,-0.413551,0.251264,-0.242792,0.15975,0.555446,0.544795,-0.500255,-0.409861,0.744245,0.202864,0.790728,-0.013854,0.243124,-0.982747,0.229937,0.866429,0.352466,-0.0469315,-0.0480624,0.13292,0.0657838,0.576543,0.441401,0.772321,0.103981,0.436959,0.220879,0.280434,0.0471384,0.208659,-0.0149516,0.146574,-0.131004,0.470349,0.496323,0.171267,-0.116103,0.430014,0.146185,0.938487,-0.770787,-0.0322172,0.568935,0.0782851,0.79591,0.525287,0.537657,0.123407,0.298414,0.168473,-0.931123,0.215576,0.539535,0.411299,0.669943,0.379337,0.0136166,0.650963,0.283735,0.254029,0.233654,0.248137,0.657056,0.485715,0.195558,0.457962,0.434429,0.374428,0.454959,-0.766827,0.0893445,0.42092,0.699547,-1.0,-0.00554085,0.743132,0.80474,-0.185367,0.681619,0.596784,0.769869,0.299452,1.0,-0.911366,0.679793]

    # @show locs_x
    # @show locs_y
    Compose.draw(PDF(name, 35cm, 35cm),
                  gplot(g, locs_x, locs_y, nodefillc=nodefillc))
                  # gplot(g,nodelabel=g.vertices,nodefillc=nodefillc))
end

end # module CoverageVisual
