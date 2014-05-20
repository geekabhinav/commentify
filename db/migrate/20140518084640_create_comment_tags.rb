class CreateCommentTags < ActiveRecord::Migration
  def change
    create_table :comment_tags do |t|
      t.integer :comment_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
