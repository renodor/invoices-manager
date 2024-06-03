# frozen_string_literal:true

class Quote < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy

  validates :date, :client_name, presence: true

  scope :ordered, -> { order(id: :desc) }
  scope :current_year, -> { where('date > ?', DateTime.new(Time.current.year, 1, 1)) }

  after_initialize :set_date, if: :new_record?

  TVA = 0.2

  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  def pdf_file_name
    "#{client_name.downcase.gsub(' ', '_')}-#{title.downcase.gsub(' ', '_')}-#{date}.pdf"
  end

  def total_without_taxes
    line_items.sum(&:total_price)
  end

  def tva
    total_without_taxes * TVA
  end

  def total
    total_without_taxes + tva
  end

  private

  def set_date
    self.date = Date.current if date.blank?
  end
end
