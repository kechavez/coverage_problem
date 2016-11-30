using LightGraphs
using StatsBase

type Agent
    loc::Int64
    cov::Int64
    com::Int64
end
function Utility(Agent, Agents, g)
  others = setdiff(Agents, Agent)
  commons = []
  for other in others
    if gdistances(g,Agent.loc)[other.loc] <= other.com
        commons = union(commons, neighborhood(g, Agent.loc, Agent.cov), neighborhood(g, other.loc, other.cov))
    end
  end
  score = length(setdiff(neighborhood(g, Agent.loc, Agent.cov), commons))
  return score
end

# N = 12
# n = 2
# g = barabasi_albert(N,1)
# Agents = []
