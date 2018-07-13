class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html {
        @notifications = current_user.notifications.order(:created_at)
      }

      format.js  {
        @notifications = current_user.unread_notifications
      }
    end
  end

  def mark_all_as_read
    @notifications = current_user.unread_notifications
    @notifications.update_all(read_at: Time.zone.now)
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
  end
end

