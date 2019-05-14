# README

This README would normally document whatever steps are necessary to get the

application up and running.

  

Things you may want to cover:

# Ruby version

> Ruby 2.5.5

> Rails 5.2.3

# Configuration

> First, change the `database.yml.sample` file to your database preferences.

> Clone the project, run `bundle install` and it should work.  
  
# Database creation

> The models already have his respective migrations, just run `rake db:setup` to build the tables on your database. 

# How to run the test suite

> To turn on the server, run `rails server`  

# Endpoints:  
  
  ## /api/v1/maps
  * POST: Accepts a JSON with the map attributes and the routes attributes to be associated with it.  
  > Example:  
  ```json
    {
      "map":{
        "name": "Rio de Janeiro",
        "routes_attributes":[
          {"initial_point":"A", "final_point":"B", "distance": 10},
          {"initial_point":"A", "final_point":"D", "distance": 5},
          {"initial_point":"B", "final_point":"C", "distance": 20},
          {"initial_point":"B", "final_point":"E", "distance": 30},
          {"initial_point":"C", "final_point":"D", "distance": 15},
          {"initial_point":"C", "final_point":"E", "distance": 50}]
          }
    }
  ```  
  > Response: Sucess (200) with the map data, or Error (422) with error(s) messages.  
  
  ## /api/v1/maps/find_routes  
  * GET: Accepts a JSON with the map name, the initial point, the final point and the cost per km to build a route and calculate his total cost.  
  > Example:  
  ```json
    {
	    "map": "Rio de Janeiro",
	    "initial_point": "A",
	    "final_point": "E",
	    "cost_per_km": 10
    }
  ```  

  > Response, if find a route (200): 
  ```json
    {
      "status": "Sucess",
      "message": "Route found",
      "data": [
          {
            "list": [
                "A",
                "B",
                "E"
            ],
            "total_distance": 40,
            "total_cost": 400
          }
        ]
    }
  ```
  > Response, if don't find a route (404):  
  ```json  
    {
      "status": "Error",
      "message": "Route do not found"
    }  
  ```  
## Automated Tests
> To check the automated tests, just run `bundle exec rspec`
