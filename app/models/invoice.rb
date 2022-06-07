# frozen_string_literal:true

class Invoice < ApplicationRecord
  include SoftDeletable

  belongs_to :user
  belongs_to :client
  has_many :line_items, dependent: :destroy
  has_many :days, dependent: :destroy

  validates :date, :number, presence: true
  validates :number, uniqueness: true
  validates :locked, inclusion: { in: [true, false] }

  scope :ordered, -> { order(id: :desc) }
  scope :current_year, -> { where('date > ?', DateTime.new(Time.current.year, 1, 1)) }

  after_initialize :set_date_and_number, if: :new_record?

  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  def pdf_file_name
    "#{number}-#{client.name.downcase.gsub(' ', '_')}-#{title.downcase.gsub(' ', '_')}-#{date}.pdf"
  end

  def total_price
    line_items.sum(&:total_price)
  end

  def self.next_number
    last_number = Invoice.current_year.last&.number&.slice(4..).to_i
    "#{Time.current.year}#{last_number + 1}"
  end

  private

  def set_date_and_number
    self.date = Date.current
    self.number = Invoice.next_number
  end
end
