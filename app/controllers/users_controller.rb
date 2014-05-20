class UsersController < ApplicationController
	before_action :set_user, :except => [:index]

	# GET /users
	# GET /users.json
	def index
		@users = User.all
	end

	# GET /users/1
	# GET /users/1.json
	def show
	end

	# GET /users/new
	def new
		@user = User.new
	end

	# GET /users/1/edit
	def edit
	end

	# POST /users
	# POST /users.json
	def create
		@user = User.new(user_params)

		respond_to do |format|
			if @user.save
				format.html { redirect_to users_path, notice: 'User was successfully created.' }
				format.json { render action: 'show', status: :created, location: @user }
			else
				format.html { render action: 'new' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /users/1
	# PATCH/PUT /users/1.json
	def update
		respond_to do |format|
			if @user.update(user_params)
				format.html { redirect_to users_path, notice: 'User was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :no_content }
		end
	end

	def get_access_token
		if @user.blank? || current_user.id != @user.id
			redirect_to edit_user_path(@user), :alert => 'Invalid User'
		elsif @user.username.blank? || @user.password_500px.blank?
			redirect_to edit_user_path(@user), :alert => 'Enter your 500px username and password before proceeding'
		else
			@user.get_token
			redirect_to edit_user_path @user
		end
	end

	def perform_action
		if @user.id != current_user.id
			redirect_to edit_user_path(@user), :alert => 'Not Authorized! Login with the user account you are trying to modify.'
		else
			status = params[:user_action].to_s
			if ['authenticated', 'active'].include?(status)
				@user.status = status
				@user.save!
				if @user.active?
					msg = 'Started bot for this user!'
				else
					msg = 'Stopped the bot for this user'
				end
				redirect_to edit_user_path(@user), :notice => msg
			else
				redirect_to edit_user_path(@user), :alert => 'Invalid status!'
			end
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_user
		@user = User.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
		params.require(:user).permit!
	end
end
