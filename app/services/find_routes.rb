class FindRoute
  def initialize(map_id, initial_point, final_point, cost_per_km)
    @map_id = map_id
    @initial_point = initial_point
    @final_point = final_point
    @cost_per_km = cost_per_km
  end

  def self.direct_route(*args)
    new(*args).direct_route
  end

  def direct_route
    @route = Route.find_by(map_id: @map_id, initial_point: @initial_point, final_point: @final_point)
    
    if @route
      return {"inital_point" => @route.initial_point,
        "final_point" => @route.final_point,
        "distace" => @route.distance,
        "final_cost" => @route.distance * @cost_per_km}
    else
      return nil
    end

  end

end