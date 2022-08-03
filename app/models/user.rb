# frozen_string_literal:true

class User < ApplicationRecord
  include SoftDeletable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :validatable

  has_many :invoices, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :banks, dependent: :destroy

  def full_name
    "#{first_name} #{last_name}"
  end

  def default_bank
    banks.find_by(is_default: true)
  end
end
