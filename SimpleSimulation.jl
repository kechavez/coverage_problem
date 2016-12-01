using LightGraphs
using StatsBase
using PyPlot
using TikzGraphs
type Agent
    loc::Int64
    cov::Int64
    com::Int64
end
# Calculates the utility of the agent
function Utility(Agent, Agents, g)
  others = setdiff(Agents, [Agent])
  coverage = neighborhood(g, Agent.loc, Agent.cov)
  Common = []
  for other in others
    if gdistances(g,Agent.loc)[other.loc] <= other.com
        CovIntersection = intersect(coverage, neighborhood(g, other.loc, other.cov))
        Common = union(Common, CovIntersection)
    end
  end
  score = length(setdiff(coverage, Common))
  return score
end

function Display(Agents)
    # Displaying the agents and their coverage and utility
    sum = 0
    for agent in Agents
      @show agent
      @show neighborhood(g, agent.loc, agent.cov)
      @show Utility(agent, Agents, g)
      sum = sum + Utility(agent, Agents, g)
    end
    # Displaying the total coverage 
    @show sum
    println(" ")
end

N = 20
n = 3
# Generating a random graph
g = random_regular_graph(N,3)
# Creating the agents randomly and storing them in a list
Agents = []
for i in range(1,n)
  push!(Agents, Agent(rand(1:N),rand(1:2), rand(1:5)))
end


Display(Agents)

# The simulation starts here
TotalCoverage = []    # a list that stores the total coverage every time step
T = 0.01         # distribution parameter

NumofIterations = 1000

for m in range(1,NumofIterations)
  agent = Agents[rand(1:length(Agents))]
  UCurr = Utility(agent, Agents, g)
  Alt = Agent(rand(neighbors(g, agent.loc)), agent.cov, agent.com)
  AgentsAlt = copy(Agents)
  AgentsAlt[findfirst(AgentsAlt, agent)] = Alt
  UAlt = Utility(Alt, AgentsAlt, g)
  choices = [UCurr, UAlt]
  p = exp(UCurr/T)/(exp(UCurr/T)+exp(UAlt/T))
  if rand() > p
    Agents = copy(AgentsAlt)
  end
  sum = 0
  for agent in Agents
    sum = sum + Utility(agent, Agents, g)
  end
  push!(TotalCoverage, sum)
end
plot(1:NumofIterations, TotalCoverage)
Display(Agents)
