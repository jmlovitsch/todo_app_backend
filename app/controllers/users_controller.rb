class UsersController < ApplicationController
    def index
        users = User.all
        render json: users.to_json(:include => :notes)
    end

    def show
        user = User.find_by(username: params[:username])
        if user
          (user.password == params[:password]) ?  (render json: user.to_json(include: :notes)) : (render json: {body: "Wrong Password"})
        else
            render json: {body: "No User Found"}
        end
    end

    def new
        user = User.new
        render json: user.to_json
    end

    def create
        puts "Backend Params"
            puts user_params
            if !User.find_by(user_params)
                new_user = User.create(user_params)
                render json: new_user.to_json
            else
                user = User.find_by(user_params)
                    if user
                    render json: user.to_json(include: :notes)
                    end
            end
    end

    def update
        user = User.find_by(id: params[:id])
        if user
            user.update(note_params)
            user.save
            render json: user.to_json(include: :notes)
            render json: {body: "Updated"}
        else
            render json: {body: "Update Unsuccessful"}
        end
    end

    def destroy
        user = User.find_by(id: params[:id])
        if user
            user.delete
            render json: {body: "Requested User Deleted"}
        else
            render json: {body: "No User Found at that ID"}
        end
    end

    private

    def user_params
        params.require(:user).permit(:username, :password)
    end

end
