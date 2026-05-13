class BorrowsController < ApplicationController
  def index
    @borrows = Borrow.includes(:user, :book).order(borrowed_at: :desc)
  end

  def new
    @books = Book.all
  end

  def create
    book = Book.find_by(id: params[:book_id])
    unless book
      respond_with_error("Book not found", :not_found)
      return
    end

    user = User.find_by(email: params[:email])
    unless user
      respond_with_error("User not found", :not_found)
      return
    end

    borrow = BorrowBookService.new(user, book).call

    respond_to do |format|
      format.html { redirect_to books_reserve_path, notice: "Book successfully reserved" }
      format.json { render json: borrow, status: :created }
    end
  rescue BorrowBookService::Error => e
    respond_with_error(e.message, :unprocessable_entity)
  end

  private

  def respond_with_error(message, status)
    respond_to do |format|
      format.html { redirect_to books_reserve_path, alert: message }
      format.json { render json: { error: message }, status: status }
    end
  end
end
