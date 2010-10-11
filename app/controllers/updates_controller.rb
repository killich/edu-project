class UpdatesController < ApplicationController
  # Обновления на сайте данного пользователя
  def index
    @update_events = @user.update_events.paginate(:all,
                           :order=>"id DESC", #ASC, DESC
                           :page => params[:page],
                           :per_page=>25
                           )
  end
end
