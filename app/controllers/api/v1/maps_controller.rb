require 'find_routes'

module Api
	module V1
		class MapsController < ApplicationController
			def index
				@maps = Map.all.as_json(include:{ routes:{ only: [:initial_point, :final_point, :distance]}}, only: :name)

				render json: {status: 'Sucess', message: 'Maps loaded', data:@maps}, status: :ok
			end

			def show
				@map = Map.find_by(id: params[:id]).as_json(include:{ routes:{ only: [:initial_point, :final_point, :distance]}}, only: :name)

				if @map
					render json: {status: 'Sucess', message: 'Map loaded', data:@map}, status: :ok
				else
					render json: {status: 'Error', message: 'Map do not exist'}, status: :not_found
				end
				
			end

			def create
				@map = Map.new(map_params)

				if @map.save
					render json: {status: 'Sucess', message: 'Map saved', data:@map.as_json(include:{ routes:{ only: [:initial_point, :final_point, :distance]}}, only: :name)}, status: :ok
				else
					render json: {status: 'Error', message: 'Map not saved', data:@map.errors}, status: :unprocessable_entity
				end
			end

			def update
				@map = Map.find_by(id: params[:id])

				if @map
					if @map.update_attributes(map_params)
						render json: {status: 'Sucess', message: 'Map updated', data:@map}, status: :ok
					else
						render json: {status: 'Error', message: 'Map not updated', data:@map.errors}, status: :unprocessable_entity
					end
				else
					render json: {status: 'Error', message: 'Map do not exist'}, status: :not_found
				end
			end

			def destroy
				@map = Map.find_by(id: params[:id])

				if @map
					if @map.destroy
						render json: {status: 'Sucess', message:'Map deleted', data:@map},status: :ok
					end
				else
					render json: {status: 'Error', message: 'Map do not exist'}, status: :not_found
				end
			end

			def find_routes
				@map = Map.find_by(name: params[:map])

				if @map
					@route, @total_distance = FindRoute.found_route(@map.id, params[:initial_point], params[:final_point])
					@total_cost = @total_distance * params[:cost_per_km]

					unless @route.nil?
						render json: {status: 'Sucess', message:'Route found', data:['list' => @route, 'total_distance' => @total_distance, 'total_cost' => @total_cost]}, status: :ok
					else
						render json: {status: 'Error', message: 'Route do not found'}, status: :not_found
					end
				else
					render json: {status: 'Error', message: 'Map do not exist'}, status: :not_found
				end
			end
			
			private
				def map_params
					params.require(:map).permit(:name,
						routes_attributes: [
							:initial_point, :final_point, :distance
						])
				end
		end
	end
end
