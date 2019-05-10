class FindRoute
  def initialize(map_id, initial_point, final_point, cost_per_km)
    @map_id = map_name
    @initial_point = initial_point
    @final_point = final_point
    @cost_per_km = cost_per_km

    #@direct_route = self.direct_route
  end

  def self.direct_route(*args)
    new(*args).direct_route
  end

  def direct_route
    @route = Route.where(map_id: @map_id, initial_point: @initial_point, final_point: @final_point)

    unless @route.empty?
      return {"inital_point" => @route.initial_point,
        "final_point" => @route.final_point,
        "distace" => @route.distance,
        "final_cost" => @route.distace * @cost_per_km
    else
      return nil
    end

  end

end