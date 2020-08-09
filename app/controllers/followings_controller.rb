class FollowingsController < ApplicationController
  before_action :find_user_by_id, only: :index

  def index
    @title = t ".title"
    @users = @user.following.page params[:page]
    render "users/show_follow"
  end
end
