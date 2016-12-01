using LightGraphs
using StatsBase

type Agent
    loc::Int64
    cov::Int64
    com::Int64
end
function Utility(Agent, Agents, g)
  others = setdiff(Agents, [Agent])
  @show others
  coverage = neighborhood(g, Agent.loc, Agent.cov)
  Common = []
  for other in others
    if gdistances(g,Agent.loc)[other.loc] <= other.com
        CovIntersection = intersect(coverage, neighborhood(g, other.loc, other.cov))
        Common = union(Common, CovIntersection)
        @show Common
    end
  end
  score = length(setdiff(coverage, Common))
  return score
end

N = 12
n = 2
g = barabasi_albert(N,1)
Agents = [Agent(1,1,4), Agent(4,1,2), Agent(6,2,3)]
for agent in Agents
  @show agent.loc
  @show neighborhood(g, agent.loc, agent.cov)
  @show Utility(agent, Agents, g)
end
