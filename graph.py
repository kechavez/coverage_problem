import networkx

name = "graph.txt"
radius = .15
n_nodes = 100

g = networkx.random_geometric_graph(n_nodes, radius)

while not networkx.is_connected(g):
  g = networkx.random_geometric_graph(n_nodes, radius)

f = open(name, 'w')

for e in g.edges():
  e2 = (e[0]+1,e[1]+1)
  f.write(str(e2[0])+' '+str(e2[1])+'\n')

f.close()
