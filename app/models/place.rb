class Place < ApplicationRecord
  belongs_to :city
  has_many   :donations
end
