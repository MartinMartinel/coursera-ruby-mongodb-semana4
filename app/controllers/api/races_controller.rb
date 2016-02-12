# solution/app/controllers/api/races_controller.rb
module Api
  class RacesController < ApplicationController

    before_action :set_race, only: [:show, :update, :destroy]
    before_action :set_entrant, only: [:results_detail]

    protect_from_forgery with: :null_session

    rescue_from Mongoid::Errors::DocumentNotFound do |exception|
      @msg = "woops: cannot find race[#{params[:id]}]"
      if !request.accept || request.accept == "*/*"
        render plain: @msg, status: :not_found
      else
        respond_to do |format|
          format.json { render "error_msg", status: :not_found, content_type: "#{request.accept}" }
          format.xml  { render "error_msg", status: :not_found, content_type: "#{request.accept}" }
        end
      end
    end

    rescue_from ActionView::MissingTemplate do |exception|
      render plain: "woops: we do not support that content-type[#{request.accept}]", :status => 415
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
        render "race", content_type: "#{request.accept}"
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
        render :partial=>"result", :object=>@result
      end 
    end

    private

      def race_params
        params.require(:race).permit(:name, :date)
      end

      def set_race
        @race = Race.find(params[:id])
      end

      def set_entrant
        @race = Race.find(params[:race_id])
        @result=@race.entrants.where(:id=>params[:id]).first
      end

  end
end