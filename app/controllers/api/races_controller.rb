# solution/app/controllers/api/races_controller.rb
module Api
  class RacesController < ApplicationController

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
        render plain: :nothing, status: :ok
      else
        #real implementation
      end
    end

    def show
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}"
      else
        #real implementation ...
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

  end
end