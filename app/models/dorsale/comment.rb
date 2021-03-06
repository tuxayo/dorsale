module Dorsale
  class Comment < ActiveRecord::Base
    belongs_to :user
    belongs_to :commentable, polymorphic: true

    validates :commentable, presence: true
    validates :text,        presence: true

    default_scope -> {
      order(created_at: :desc)
    }
  end
end
