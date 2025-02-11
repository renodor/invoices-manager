# frozen_string_literal:true

class Bank < ApplicationRecord
  belongs_to :user
  has_many :invoices

  validates :name, :bic, :iban, presence: true
  validates :is_default, uniqueness: { scope: :user_id }, if: :is_default
end
