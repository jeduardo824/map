require 'rails_helper'

RSpec.describe "Maps", type: :request do
  describe "POST /maps" do

    context 'creating map' do
      it 'with valid name, returns status code 200' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "São Paulo", "routes_attributes": @routes}

        post '/api/v1/maps', params: {"map": @map}
        puts response.body

        expect(response).to have_http_status(200)
      end

      it 'with invalid name, returns status code 422' do
        @map = {"name": 22, "routes_attributes": []}

        post '/api/v1/maps', params: {"map": @map}
        puts response.body

        expect(response).to have_http_status(422)
      end
    end

    context 'creating maps with same names' do
      it 'the fist returns status code 200 and the second returns status code 422' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "São Paulo", "routes_attributes": @routes}

        post '/api/v1/maps', params: {"map": @map}
        expect(response).to have_http_status(200)

        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "São Paulo", "routes_attributes": @routes}

        post '/api/v1/maps', params: {"map": @map}
        puts response.body

        expect(response).to have_http_status(422)
      end
    end

    context 'creating maps with different names but with the same routes' do
      it 'both return status code 200' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "São Paulo", "routes_attributes": @routes}

        post '/api/v1/maps', params: {"map": @map}

        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "Rio de Janeiro", "routes_attributes": @routes}

        post '/api/v1/maps', params: {"map": @map}
        puts response.body

        expect(response).to have_http_status(200)
      end
    end

    context 'creating map with invalid routes' do
      it 'with invalid routes, returns status code 422' do
        @routes = [{"initial_point": 22, "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "São Paulo", "routes_attributes": @routes}

        post '/api/v1/maps', params: {"map": @map}
        puts response.body

        expect(response).to have_http_status(422)
      end

      it 'without routes, returns status code 422' do
        @map = {"name": "São Paulo"}

        post '/api/v1/maps', params: {"map": @map}
        puts response.body

        expect(response).to have_http_status(422)
      end
    end
  end

  describe "GET /maps" do

    context 'getting all maps' do
      it 'with #index' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "São Paulo", "routes_attributes": @routes}
        post '/api/v1/maps', params: {"map": @map}

        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "Rio de Janeiro", "routes_attributes": @routes}
        post '/api/v1/maps', params: {"map": @map}

        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20}]
        @map = {"name": "Belo Horizonte", "routes_attributes": @routes}
        post '/api/v1/maps', params: {"map": @map}

        get '/api/v1/maps'
        puts response.body

        expect(response).to have_http_status(200)
      end
    end
  end

  describe "GET /maps/find_routes" do

    context 'existent route' do
      it 'with 5 routes' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20},
          {"initial_point": "C", "final_point": "D", "distance": 15},
          {"initial_point": "C", "final_point": "E", "distance": 5},
          {"initial_point": "A", "final_point": "E", "distance": 40}]

        @map = {"name": "São Paulo", "routes_attributes": @routes}
        post '/api/v1/maps', params: {"map": @map}
        
        @route = {"map": "São Paulo", "initial_point": "A", "final_point": "E", "cost_per_km": 15}
        get '/api/v1/maps/find_routes', params: @route

        res = JSON.parse(response.body).with_indifferent_access

        puts response.body

        expect(response).to have_http_status(200)
        expect(res["data"]).to contain_exactly({list:["A","B","C","E"], total_distance:35, total_cost:525.0})
      end

      it 'with 5 routes again' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20},
          {"initial_point": "C", "final_point": "D", "distance": 15},
          {"initial_point": "C", "final_point": "E", "distance": 5},
          {"initial_point": "A", "final_point": "E", "distance": 10}]

        @map = {"name": "São Paulo", "routes_attributes": @routes}
        post '/api/v1/maps', params: {"map": @map}
        
        @route = {"map": "São Paulo", "initial_point": "A", "final_point": "E", "cost_per_km": 15}
        get '/api/v1/maps/find_routes', params: @route

        res = JSON.parse(response.body).with_indifferent_access

        puts response.body

        expect(response).to have_http_status(200)
        expect(res["data"]).to contain_exactly({list:["A", "E"], total_distance:10, total_cost:150.0})
      end
    end

    context 'inexistent route' do
      it 'with 6 routes' do
        @routes = [{"initial_point": "A", "final_point": "B", "distance": 10},
          {"initial_point": "B", "final_point": "C", "distance": 20},
          {"initial_point": "C", "final_point": "D", "distance": 15},
          {"initial_point": "C", "final_point": "E", "distance": 5},
          {"initial_point": "A", "final_point": "F", "distance": 5},
          {"initial_point": "A", "final_point": "E", "distance": 40}]

        @map = {"name": "São Paulo", "routes_attributes": @routes}
        post '/api/v1/maps', params: {"map": @map}
        
        @route = {"map": "São Paulo", "initial_point": "B", "final_point": "F", "cost_per_km": 15}
        get '/api/v1/maps/find_routes', params: @route

        res = JSON.parse(response.body).with_indifferent_access

        puts response.body

        expect(response).to have_http_status(404)
        expect(res["message"]).to eql("Route do not found")
      end
    end
  end

end