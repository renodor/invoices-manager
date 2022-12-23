# frozen_string_literal:true

class Invoice < ApplicationRecord
  include SoftDeletable

  belongs_to :user
  belongs_to :client
  belongs_to :bank
  has_many :line_items, dependent: :destroy
  has_many :days, dependent: :destroy

  validates :date, :number, presence: true
  validates :number, uniqueness: { scope: :user_id }
  validates :locked, inclusion: { in: [true, false] }

  scope :ordered, -> { order(id: :desc) }
  scope :current_year, -> { where('date > ?', DateTime.new(Time.current.year, 1, 1)) }

  after_initialize :set_date_and_number, if: :new_record?
  before_validation :set_bank, if: :new_record?

  TVA = 0.2

  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  def pdf_file_name
    "#{number}-#{client.name.downcase.gsub(' ', '_')}-#{title.downcase.gsub(' ', '_')}-#{date}.pdf"
  end

  def total_without_taxes
    line_items.sum(&:total_price)
  end

  def tva
    total_without_taxes * TVA
  end

  def total
    with_tva ? total_without_taxes + tva : total_without_taxes
  end

  private

  def set_date_and_number
    self.date = Date.current if date.blank?

    last_number = user&.invoices&.current_year&.last&.number&.slice(4..).to_i
    self.number = "#{Time.current.year}#{last_number + 1}"
  end

  def set_bank
    self.bank = user&.default_bank
  end
end
