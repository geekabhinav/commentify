class Comment < ActiveRecord::Base
  has_many :comment_tags, :dependent => :destroy
  has_many :tags, :through => :comment_tags
  validates_presence_of :body
end
