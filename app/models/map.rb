class Map < ApplicationRecord
    validates :name, presence: true, uniqueness: true, format: { with: /\A[a-zA-Z\ \u00C0-\u00FF]+\z/ }
    has_many :routes, dependent: :destroy
    accepts_nested_attributes_for :routes, reject_if: :all_blank
    validates :routes, presence: true
end
