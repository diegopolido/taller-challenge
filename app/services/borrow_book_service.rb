class BorrowBookService
  class Error < StandardError; end
  class AlreadyBorrowedError < Error; end
  class NoCopiesAvailableError < Error; end

  def initialize(user, book)
    @user = user
    @book = book
  end

  def call
    raise AlreadyBorrowedError, "Already borrowed by #{@user.email}" if already_borrowed?
    raise NoCopiesAvailableError, "No copies available" if @book.unavailable?

    borrow = Borrow.create!(
      user: @user,
      book: @book,
      borrowed_at: Time.current,
      due_date: 2.weeks.from_now
    )

    @book.update(status: book_status)
    borrow
  end

  private

  def book_status
    return :reserved if @book.unavailable?

    :available
  end

  def already_borrowed?
    @user.borrows.where(book: @book, returned_at: nil).exists?
  end
end
