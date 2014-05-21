class Activity < ActiveRecord::Base
  belongs_to :user
  default_scope order('created_at DESC')

  def link
    "http://500px.com/photo/#{self.photo_id.to_s}/"
  end

  def self.add(type, photo_id, user_id)
    Activity.create!({
        :action_type => type,
        :photo_id => photo_id,
        :user_id => user_id.to_i
    })
  end
end