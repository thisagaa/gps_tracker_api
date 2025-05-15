class EventsController < ApplicationController
    def create # POST endpoint
        event = Event.new(event_params)

        if Event.exists?(uuid: event.uuid)
            render json: { error: "UUID already exists, use a new one" }, status: :unprocessable_entity
            return
        end

        if event.save
            render json: event, status: :ok
        else
            render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end

    rescue ActionController::ParameterMissing
        render json: { error: "Invalid request format" }, status: :bad_request
    rescue ActiveRecord::NotNullViolation
        render json: { error: "Missing required fields" }, status: :unprocessable_entity
    rescue ActiveRecord::RecordInvalid => e # Returns a clean JSON error if event.save fails
        render json: { error: e.message }, status: :unprocessable_entity
    end

    def show # GET EVENT/uuid
        event = Event.find_by(uuid: params[:id])

        if event
            render json: event
        else
            render json: { error: "Event not found" }, status: :not_found
        end
    end

    def index # GET EVENTS
        event = Event.all
        render json: event
    end

    def update # PUT / PATCH
        event = Event.find_by(uuid: params[:id])

        if event.nil?
            render json: { error: "Event not found" }, status: :not_found
            return
        end

        if event.notification_sent # prevent setting to true if notification already true
            render json: { error: "Notification already sent" }, status: :bad_request
            return
        end

        if event.update(notification_sent: true)
            render json: event, status: :ok
        else
            render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy # DELETE
        event = Event.find_by(uuid: params[:id])

        if event.nil?
            render json: { error: "Event not found" }, status: :not_found
            return
        end

        if event.is_deleted
            render json: { error: "Event already deleted" }, status: :bad_request
            return
        end

        if event.update(is_deleted: true)
            head :no_content
        else
            render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
    end
    private
    def event_params
        params.require(:event).permit(
            :uuid, :recorded_at, :received_at, :category, :device_uuid, :metadata, :notification_sent, :is_deleted
        )
    end
end
