class Book < ApplicationRecord
  validates :title, :author, :genre, :total_copies, presence: true
  has_many :borrows

  def unavailable?
    return false if total_copies.nil? || total_copies&.zero?
    return true if borrows.nil?

    borrows.where(returned_at: nil).count >= total_copies
  end
end
