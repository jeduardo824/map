module Api
	module V1
		class MapsController < ApplicationController
			def index
				@maps = Map.includes(:routes).all
				render json: {status: 'Sucess', message: 'Maps loaded', data:@maps}, status: :ok
			end

			def show
				@map = Map.find_by(id: params[:id])

				if @map
					render json: {status: 'Sucess', message: 'Map loaded', data:@map}, status: :ok
				else
					render json: {status: 'Error', message: 'Map do not exist'}, status: :not_found
				end
				
			end

			def create
				@map = Map.new(map_params)

				if @map.save
					render json: {status: 'Sucess', message: 'Map saved', data:@map}, status: :ok
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
					@map.destroy
					render json: {status: 'Sucess', message:'Map deleted', data:@map},status: :ok
				else
					render json: {status: 'Error', message: 'Map do not exist'}, status: :not_found
				end
			end

			def find_route
				@map = Map.find_by(name: params[:name])

				if @map
					@route = FindRoute.direct_route(@map.id, @map.initial_point, @map.final_point, @map.cost_per_km)
					unless @route.nil?
						render json: {status: 'Sucess', message:'Route found', data:@route},status: :ok
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
