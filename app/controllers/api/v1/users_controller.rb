class Api::V1::UsersController < ApplicationController
  before_action :find_user, only: %i[show update destroy]
  before_action :check_owner, only: %i[update destroy]

  def index
    @users = User.all
    render json: UserSerializer.new(@users).serializable_hash.to_json
  end

  def show
    options = { include: [:bugs] }
    render json: UserSerializer.new(@user, options).serializable_hash.to_json
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: UserSerializer.new(@user).serializable_hash.to_json, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :role)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def check_owner
    head :forbidden unless @user.id == current_user&.id
  end
end
