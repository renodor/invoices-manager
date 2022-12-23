# frozen_string_literal:true

module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :not_deleted, -> { where(deleted_at: nil) }
    scope :deleted, -> { where.not(deleted_at: nil) }
  end

  def destroy(do_i_really_want_to_do_it: false)
    if do_i_really_want_to_do_it
      super()
    else
      update(deleted_at: DateTime.current)
    end
  end
  alias delete destroy

  def destroy!(do_i_really_want_to_do_it: false)
    if do_i_really_want_to_do_it
      destroy(do_i_really_want_to_do_it: true) || _raise_record_not_destroyed
    else
      update!(deleted_at: DateTime.current)
    end
  end
  alias delete! destroy!
end
