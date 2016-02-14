# solution/app/controllers/api/races_controller.rb
module Api
  class RacesController < ApplicationController

    before_action :set_race, only: [:update, :destroy]
    before_action :set_entrant, only: [:results_detail_update]

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
        msg = ""
        if params[:race]
          if params[:race][:name]
            msg = params[:race][:name]
          end
        end
        render plain: msg, status: :ok 
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
        set_race
        render "race", content_type: "#{request.accept}"
      end       
    end

    def results
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:id]}/results"
      else
        set_race
        max_last_modified = @race.entrants.max(:updated_at)
        if_modified_since = request.headers['If-Modified-Since']
        puts "****#{if_modified_since}****"
        if stale?(last_modified: max_last_modified)
          @entrants=@race.entrants  
        end
        #fresh_when last_modified: @race.entrants.max(:updated_at)
      end       
    end

    def results_detail
      if !request.accept || request.accept == "*/*"
        render plain: "/api/races/#{params[:race_id]}/results/#{params[:id]}"
      else
        set_entrant
        render :partial=>"result", :object=>@result
      end 
    end

    def results_detail_update
      #puts "*****#{result_params}****"
      if result_params
        if result_params[:swim]
          @result.swim=@result.race.race.swim
          @result.swim_secs = result_params[:swim].to_f
        end
        if result_params[:t1]
          @result.t1=@result.race.race.t1
          @result.t1_secs = result_params[:t1].to_f
        end
        if result_params[:bike]
          @result.bike=@result.race.race.bike
          @result.bike_secs = result_params[:bike].to_f
        end
        if result_params[:t2]
          @result.t2=@result.race.race.t2
          @result.t2_secs = result_params[:t2].to_f
        end
        if result_params[:run]
          @result.run=@result.race.race.run
          @result.run_secs = result_params[:run].to_f
        end        
        @result.save
      end
      render json: @result
    end

    private

      def race_params
        params.require(:race).permit(:name, :date)
      end

      def result_params
        params.require(:result).permit(:swim, :t1, :bike, :t2, :run)
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