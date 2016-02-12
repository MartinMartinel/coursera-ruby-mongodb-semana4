# solution/app/controllers/api/races_controller.rb
module Api
  class RacesController < ApplicationController

    before_action :set_race, only: [:show, :update, :destroy, :results, :results_detail]

    protect_from_forgery with: :null_session

    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      render plain: "woops: cannot find race[#{params[:id]}]", status: :not_found
    end

    def index
      if !request.accept || request.accept == "*/*"
        offset = ", offset=[#{params[:offset]}]" if  params[:offset]
        limit = ", limit=[#{params[:limit]}]" if  params[:limit]
        render plain: "/api/races#{offset}#{limit}"
      else
        #real implementation ...
      end      
    end

    def create
      if !request.accept || request.accept == "*/*"
        #render plain: :nothing, status: :ok
        render plain: params[:race][:name], status: :ok if params[:race][:name]
      else
        race = Race.create(race_params)
        render plain: race.name, status: :created
      end
    end

    def update
      #Rails.logger.debug("method=#{request.method}")
      @race.update_attributes(race_params)
      render json: @race
    end

    def destroy
      @race.destroy
      render :nothing=>true, :status => :no_content
    end

    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      else
        render json: @race
      end       
    end

    def results
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results"
      else
        #real implementation ...
      end       
    end

    def results_detail
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        #real implementation ...
      end 
    end

    private

      def race_params
        params.require(:race).permit(:name, :date)
      end

      def set_race
        @race = Race.find(params[:id])
      end

  end
end