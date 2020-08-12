class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_followed_user, only: :create
  before_action :load_unfollowed_user, only: :destroy

  def create
    current_user.follow @followed_user
    response_ajax
    redirect_to @followed_user
  end

  def destroy
    current_user.unfollow @unfollowed_user
    response_ajax
    redirect_to @unfollowed_user
  end

  private
  
  def load_followed_user
    @followed_user = User.find_by followed_id: params[:followed_id]
    return if @followed_user

    flash[:danger] = t "users.user_not_found"
    redirect_to request.referer
  end

  def load_unfollowed_user
    @unfollowed_user = Relationship.find_by(id: params[:id]).followed
    return if @unfollowed_user

    flash[:danger] = t "users.user_not_found"
    redirect_to request.referer
  end

  def response_ajax
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
