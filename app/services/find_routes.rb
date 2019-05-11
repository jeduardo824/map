require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/graph_visitor'

class FindRoute

  def initialize(map_id, initial_point, final_point)
    @map_id = map_id
    @initial_point = initial_point
    @final_point = final_point
  end

  def self.found_route(*args)
    new(*args).found_route
  end

  def found_route
    graph = RGL::DirectedAdjacencyGraph.new
    visitor = RGL::DijkstraVisitor.new(graph)
    visitor.attach_distance_map()
    edge_weights = {}
    routes = Route.where(map_id: @map_id)
    routes.each do |route|
      graph.add_vertices route.initial_point, route.final_point
      graph.add_edge(route.initial_point, route.final_point)
      edge_weights[[route.initial_point, route.final_point]] = route.distance
    end

    matrix = RGL::DijkstraAlgorithm.new(graph, edge_weights, visitor)
    matrix.shortest_path(@initial_point, @final_point)
    return matrix.shortest_path(@initial_point, @final_point), visitor.distance_to_root(@final_point)

  end

  

end