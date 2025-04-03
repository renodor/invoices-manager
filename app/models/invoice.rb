# frozen_string_literal:true

class Invoice < ApplicationRecord
  include SoftDeletable
  include FinancialMethods

  belongs_to :user
  belongs_to :client
  belongs_to :bank
  has_many :line_items, dependent: :destroy
  has_many :days, dependent: :destroy

  validates :date, :number, :flavor, presence: true
  validates :number, uniqueness: { scope: :user_id }
  validates :locked, inclusion: { in: [true, false] }

  scope :ordered, -> { order(id: :desc) }
  scope :current_year, -> { where("date > ?", DateTime.new(Time.current.year, 1, 1)) }

  enum :flavor, {
    with_tva: 0,
    without_tva: 1,
    outside_eu: 2
  }

  after_initialize :set_date_and_number, if: :new_record?
  before_validation :set_bank, if: :new_record?

  def pretty_date
    date.strftime("%d/%m/%Y")
  end

  def pdf_file_name
    "#{number}-#{client.name.downcase.gsub(' ', '-')}-#{title.downcase.delete('-').delete(',').gsub(' ', '-').gsub('--', '-')}.pdf"
  end

  def tva_cgi_article
    case flavor
    when "without_tva"
      "293 B"
    when "outside_eu"
      "259-1"
    end
  end

  private

  def set_date_and_number
    self.date = Date.current if date.blank?

    last_number = user&.invoices&.current_year&.last&.number&.split("-")&.last.to_i
    self.number = "FAC-#{Time.current.year}-#{last_number + 1}"
  end

  def set_bank
    self.bank = user&.default_bank
  end
end
