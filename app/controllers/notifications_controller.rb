class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    respond_to do |format|
      format.html {
        @notifications = current_user.notifications.order(created_at: :desc)
      }

      format.js  {
        if params[:filter]
          @feed = Notification.feed({ filter: params[:filter], 
                                  sorter: params[:sorter], user: current_user })

        else
          @notifications = current_user.unread_notifications
        end
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

