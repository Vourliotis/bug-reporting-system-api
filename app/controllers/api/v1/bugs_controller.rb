class Api::V1::BugsController < ApplicationController
  before_action :find_bug, only: %i[show update destroy]
  before_action :check_login, only: %i[create]
  before_action :check_owner, only: %i[update destroy]

  def index
    @bugs = Bug.all
    render json: BugSerializer.new(@bugs).serializable_hash.to_json
  end

  def show
    options = { include: [:user] }
    render json: BugSerializer.new(@bug, options).serializable_hash.to_json
  end

  def create
    bug = current_user.bugs.build(bug_params)
    if bug.save
      render json: BugSerializer.new(bug).serializable_hash.to_json, status: :created
    else
      render json: { errors: bug.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @bug.update(bug_params)
      render json: BugSerializer.new(@bug).serializable_hash.to_json
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
