class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data UserRegistrationReport.report @competition }
    end
  end

  def mailing_list_export
    respond_to do |format|
      format.csv { send_data MailingListExport.new(@competition).to_csv }
    end
  end

  def show
    @user = User.find params[:id]
    @profile = @user.profile
  end

  def confirm
    (@user = User.find params[:id]).confirm
    if @user.confirmed?
      redirect_to admin_user_path(@user), notice: 'User confirmed'
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
      render :show
    end
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges? Competition.all

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def user_params
    params.require(:user).permit :full_name, :email
  end
end
