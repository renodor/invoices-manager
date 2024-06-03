# frozen_string_literal:true

class LineItem < ApplicationRecord
  belongs_to :invoice, optional: true
  belongs_to :quote, optional: true

  validates :description, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than: 0, less_than: 1_000_000 }

  scope :ordered, -> { order(id: :asc) }

  def total_price
    quantity * unit_price
  end
end
