class Admin::UserRolesController < ApplicationController
  before_action :redirect_unless_admin
  before_action :set_user, only: [:edit, :update, :destroy]
  
  def index
    @users = User.all
  end

  def edit
    @user
  end

  def update
    @user.update(user_params)
    if @user.save
      redirect_to admin_user_roles_path
    else
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :admin)
  end
end