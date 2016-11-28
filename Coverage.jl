using LightGraphs
using StatsBase

N = 12
n = 2
g = Graph(N)
add_edge!(g,1,2)

AgentsLoc = sample(1:N, n, replace = false)
AgentsCoverage = Dict()
for agent in AgentsLoc
  AgentsCoverage[agent] = neighbors(g,agent)
end
