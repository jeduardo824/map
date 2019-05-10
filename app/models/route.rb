class Route < ApplicationRecord
  belongs_to :map
  validates :initial_point, :final_point, presence: true, format: { with: /\A[a-zA-Z\ \u00C0-\u00FF]+\z/ }
  validates :distance, presence: true, numericality: { greater_than: 0 }
end
