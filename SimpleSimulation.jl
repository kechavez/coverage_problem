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
    # loc = rand(1:N)
    if i <= 10
      push!(Agents, Agent(25, cov1, com1))
    else
      push!(Agents, Agent(25, cov2, com2))
    end
end

Display(Agents)

# The simulation starts here
TotalCoverage = []    # a list that stores the total coverage every time step
T = 0.1         # distribution parameter

NumofIterations = 5000

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
  # push!(TotalCoverage, sum)
  push!(TotalCoverage, Potential(g,Agents))
end
PyPlot.plot(1:NumofIterations, TotalCoverage)
Display(Agents)

xlabel("Time")
ylabel("Utility Sum")
savefig("blll_cov_plot.pdf",format="pdf")
visualize_graph(g, Agents, "blll_cov_graph.pdf")
println("Done.")
