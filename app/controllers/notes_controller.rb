class NotesController < ApplicationController

    def index
        notes = Note.all
        render json: notes.to_json(:include => {:user => {:only => [:id]}})
    end

    def show
        note = Note.find_by(id: params[:id])
        if note
            render json: note.to_json(include: :user)
        else
            render json: {body: "No Note Found"}
        end
    end

    def create
        note = Note.new(note_params)
        note.save
        render json: {body: note}
    end

    def update
        note = Note.find_by(id: params[:id])
        if note
            note.update(note_params)
            note.save
            render json: note.to_json(:include => {:user => {:only => [:id]}})
        else
            render json: {body: "Update Unsuccessful"}
        end
    end

    def destroy
        note = Note.find_by(id: params[:id])
        if note
            note.delete
            render json: {body: "Requested Note Deleted"}
        else
            render json: {body: "No Note Found at that ID"}
        end
    end

    private

    def note_params
        params.require(:note).permit(:title, :content, :user_id)
    end

end
