class Lecture < ApplicationRecord
  validates_uniqueness_of :title
end
