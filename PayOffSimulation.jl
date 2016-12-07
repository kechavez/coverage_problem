push!(LOAD_PATH,pwd())
using CoverageVisual
using Compose

using LightGraphs
using StatsBase
using PyPlot
using TikzGraphs
type Agent
    loc::Int64
    cov::Int64
    com::Int64
    PrevAct::Int64
    Ut_1::Int64
    Ut::Int64
    x::Bool
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
    loc = rand(1:N)
    push!(Agents, Agent(loc,rand(1:2), rand(1:5), 0, 0, 0, 0))
end

for agent in Agents
  agent.Ut = Utility(agent, Agents, g)
end
Display(Agents)

# The simulation starts here
TotalCoverage = []    # a list that stores the total coverage every time step
T = 0.01         # distribution parameter

NumofIterations = 10000
w = 0.5           # Exploration parameter
for m in range(1,NumofIterations)
  for agent in Agents
    if agent.x == 0 && rand() < w
            agent.PrevAct = agent.loc
      agent.loc = rand(setdiff(neighbors(g, agent.loc), [agent.loc]))
      agent.x = 1
      agent.Ut_1 = agent.Ut
        
    elseif agent.x == 1
      p = exp(agent.Ut/T)/(exp(agent.Ut/T)+exp(agent.Ut_1/T))

      if rand() > p
        agent.loc = agent.PrevAct
      end
      agent.x = 0
    end  
  end

  sum = 0
  for agent in Agents
    agent.Ut = Utility(agent, Agents, g)
    sum = sum + agent.Ut
  end
  push!(TotalCoverage, sum)
end
PyPlot.plot(1:NumofIterations, TotalCoverage)
Display(Agents)

xlabel("Time")
ylabel("Utility Sum")
savefig("cov_plot.pdf",format="pdf")
visualize_graph(g, Agents)
println("Done.")
