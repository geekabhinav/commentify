class Activity < ActiveRecord::Base
  belongs_to :user

  def link
    "http://500px.com/photo/#{self.photo_id.to_s}/"
  end

  def self.add(type, photo_id, user_id)
    Activity.create!({
        :type => type,
        :photo_id => photo_id,
        :user_id => user_id.to_i
    })
  end

end
