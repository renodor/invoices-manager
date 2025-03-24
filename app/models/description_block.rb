# frozen_string_literal: true

class DescriptionBlock < ApplicationRecord
  belongs_to :quote

  scope :ordered, -> { order(:position) }

  validates :text, :position, :flavor, presence: true

  enum :flavor, {
    title: 0,
    text: 1,
    list: 2
  }
end
