class User < ApplicationRecord
  validates :first, presence: true
end
