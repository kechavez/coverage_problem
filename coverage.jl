using GraphPlot
using Graphs
using LightGraphs
using Colors
using DataStructures

graph_plot_num = 1

type Agent
    v::Int64
    cov::Int64
    com::Int64
end

function color_agent_coverage(g, agents, mems)
  # Color coverage using color2.
  for a in agents
     visited = false*Array{Bool,1}(num_vertices(g))
     q = Queue(Tuple)
     enqueue!(q, (a.v, a.cov))
     while !isempty(q)
       start,cov = dequeue!(q)
       mems[start] = 2
       if cov != 0
        for n in in_neighbors(start, g)
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
      mems[a.v] = 3
  end
end

function visualize_graph(g, agents)
  # color1 -- not covered
  # color2 -- covered
  # color3 -- agent
  nodecolor = [colorant"darksalmon", colorant"gray90",colorant"gray45"]
  membership =  Array{Int64,1}(ones(34))*1
  nodelabel = 1:num_vertices(g)
  color_agent_coverage(g, as, membership)
  nodefillc = nodecolor[membership] 
  gplot(g, nodelabel=nodelabel, nodefillc=nodefillc)
end

## Test graph ##
# g = graphfamous("karate")
# as = [Agent(12,2), Agent(17,2), Agent(25,1)]
# visualize_graph(g,as)
