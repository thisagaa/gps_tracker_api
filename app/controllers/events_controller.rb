class EventsController < ApplicationController
    def create # POST endpoint
        event = Event.new(event_params)
        if event.save
            render json: event, status: :ok
        else
            render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end

    rescue ActionController::ParameterMissing
        render json: { error: "Invalid request format" }, status: :bad_request
    end

    def show # GET EVENT/uuid
        event = Event.find_by(uuid: params[:id])

        if event
            render json: event
        else
            render json: { error: "Event not found" }, status: :not_found
        end
    end

    def index
        event = Event.all
        render json: event
    end

    private
    def event_params
        params.require(:event).permit(
            :uuid, :recorded_at, :received_at, :category, :device_uuid, :metadata, :notification_sent, :is_deleted
        )
    end
end
