class BorrowBookService
  class AlreadyBorrowError < Error; end
  class NoCopiesAvailableError < Error; end

  def initialize(user, book)
    @user = user
    @book = book
  end

  def call
    raise AlreadyBorrowError, "Already borrowed" if already_borrowed?
    raise NoCopiesAvailableError, "No copies available" if @book.unavailable?

    Borrow.create!(
      user: @user,
      book: @book,
      borrowed_at: Time.current,
      due_date: 2.weeks.from_now
    )
  end

  private

  def already_borrowed?
    @user.borrows.where(book: @book, returned_at: nil).exists?
  end
end
