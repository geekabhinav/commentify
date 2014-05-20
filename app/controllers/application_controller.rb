class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :authenticate_user!

# 1. Get list of 50 links from fresh_today queue using rake task and cron job
# 2. Loops through each and add it to queue for posting comments and like
# 3. In queue, check if user.activities has the photo's id, if yes, abort -- DONE
# 4. Repeat!

end
