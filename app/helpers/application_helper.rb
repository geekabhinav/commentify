#encoding: utf-8
module ApplicationHelper
	# To include specific JS files
	def javascript(*files)
		content_for(:footer) { javascript_include_tag(*files) }
	end

	# To include specific stylesheet files
	def stylesheet(*files)
		content_for(:head) { stylesheet_link_tag(*files) }
	end

	# Method to handle notice and error messages
	def flash_messages
		bootstrap_message_map = {
				notice: 'info',
				alert:  'danger'
		}
		[:notice, :alert].collect do |key|
			unless flash[key].blank?
				content_tag(:div, :class => "alert alert-#{bootstrap_message_map[key]} fade in") do
					"<button type=\"button\" class=\"close\" data-dismiss=\"alert\">×</button> #{flash[key]}".html_safe
				end
			end
		end.join.html_safe
	end


  def get_statement(activity)
    "#{activity.user.username.to_s} #{activity.action_type == 'like' ? 'liked' : 'commented on'} Photo ID: <a href=\"http://500px.com/photo/#{activity.photo_id.to_s}\" class='link' target='_blank'>#{activity.photo_id.to_s}</a> | #{time_ago_in_words(activity.created_at)} ago."
  end
end
