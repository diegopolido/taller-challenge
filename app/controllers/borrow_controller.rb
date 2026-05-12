class BorrowController < ActionController::Base
  def create
    book = Book.find_by(id: params[:book_id])
    unless book
      render json: { error: "Book not found" }, status: :not_found
      return
    end
    user = User.find_by(email: params[:email])

    unless user
      render json: { error: "User not found" }, status: :not_found
      return
    end

    borrow = BorrowBookService.new(user, book).call

    render json: borrow, status: :created
  end
end
