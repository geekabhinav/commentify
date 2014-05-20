class Tag < ActiveRecord::Base
  has_many :comment_tags, :dependent => :destroy
  has_many :comments, :through => :comment_tags
  validates_uniqueness_of :name
  validates_presence_of :name
end
