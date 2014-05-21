class RenameTypeInActivities < ActiveRecord::Migration
  def change
    rename_column :activities, :type, :action_type
  end
end
