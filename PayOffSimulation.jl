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

function Potential(g, agents)
  covered = []
  for a in agents
    covered = union(covered,neighborhood(g, a.loc, a.cov))
  end
  return length(covered)
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

N = 100
n = 15

# Generating a random graph
# g = random_regular_graph(N,3)

# read graph file
f = open("graph.txt")
s = [replace(x, '\n', "") for x in readlines(f)]
elist = [(parse(Int64, split(s[i])[1]), parse(Int64, split(s[i])[2])) for i in 1:length(s)]
g = Graph(N)
for e in elist
  add_edge!(g, e[1], e[2])
end

cov1 = 1
cov2 = 2
com1 = 4
com2 = 5
# Creating the agents randomly and storing them in a list
Agents = []
for i in range(1,n)
    loc = rand(1:N)
    if i <= 10
      push!(Agents, Agent(25, cov1, com1, 0, 0, 0, 0))
    else
      push!(Agents, Agent(25, cov2, com2, 0, 0, 0, 0))
    end
end

for agent in Agents
  agent.Ut = Utility(agent, Agents, g)
end
Display(Agents)

# The simulation starts here
TotalCoverage = []    # a list that stores the total coverage every time step
T = 0.01         # distribution parameter

NumofIterations = 5000
w = 0.5       # Exploration parameter
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
  # push!(TotalCoverage, sum)
  push!(TotalCoverage, Potential(g, Agents))
end
PyPlot.plot(1:NumofIterations, TotalCoverage)
Display(Agents)

xlabel("Time")
ylabel("Utility Sum")
savefig("payoff_cov_plot.pdf",format="pdf")
visualize_graph(g, Agents, "payoff_cov_graph.pdf")
println("Done.")
