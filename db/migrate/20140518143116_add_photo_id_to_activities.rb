class AddPhotoIdToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :photo_id, :integer
    remove_column :activities, :url
  end
end
