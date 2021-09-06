class Api::V1::BugsController < ApplicationController
  before_action :find_bug, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  def index
    render json: Bug.all
  end

  def show
    render json: @bug
  end

  def create
    bug = current_user.bugs.build(bug_params)
    if bug.save
      render json: bug, status: :created
    else
      render json: { errors: bug.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @bug.update(bug_params)
      render json: @bug
    else
      render json: @bug.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @bug.destroy
    head 204
  end

  private

  def bug_params
    params.require(:bug).permit(:title, :description, :priority, :status, :comments)
  end

  def find_bug
    @bug = Bug.find(params[:id])
  end

  def check_owner
    head :forbidden unless @bug.user_id == current_user&.id
  end

  def set_bug
    @bug = Bug.find(params[:id])
  end
end
