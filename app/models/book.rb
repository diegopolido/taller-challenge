class Book < ApplicationRecord
  validates :title, :author, :genre, :total_copies, presence: true
  has_many :borrows

  def status
    return :reserved if unavailable?

    :available
  end

  private

  def unavailable?
    @book.borrows.where(returned_at: nil).count >= @book.total_copies
  end
end
