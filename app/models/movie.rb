class Movie < ActiveRecord::Base
  def self.ratings
	self.uniq.pluck(:rating).sort_by
  end
end
