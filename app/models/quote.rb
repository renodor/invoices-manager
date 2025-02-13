# frozen_string_literal:true

class Quote < ApplicationRecord
  include FinancialMethods

  belongs_to :user
  has_many :line_items, dependent: :destroy

  validates :date, :number, :client_name, presence: true
  validates :number, uniqueness: { scope: :user_id }

  scope :ordered, -> { order(id: :desc) }
  scope :current_year, -> { where('date > ?', DateTime.new(Time.current.year, 1, 1)) }

  enum :flavor, {
    with_tva: 0,
    without_tva: 1,
    outside_eu: 2
  }

  after_initialize :set_date_and_number, if: :new_record?

  def pretty_date
    date.strftime('%d/%m/%Y')
  end

  def pdf_file_name
    "#{title.downcase.delete('-').delete(',').gsub(' ', '-').gsub('--', '-')}-#{user.first_name.downcase}-#{user.last_name.downcase}.pdf"
  end

  def tva_cgi_article
    case flavor
    when 'without_tva'
      '293 B'
    when 'outside_eu'
      '259-1'
    end
  end

  private

  def set_date_and_number
    self.date = Date.current if date.blank?

    last_number = user&.quotes&.current_year&.last&.number&.split('-')&.last.to_i
    self.number = "DEV-#{Time.current.year}-#{last_number + 1}"
  end
end
