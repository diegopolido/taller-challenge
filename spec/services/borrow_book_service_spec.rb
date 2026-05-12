require 'rails_helper'

RSpec.describe BorrowBookService do
  let(:user) { create(:user) }
  let(:book) { create(:book, total_copies: 1) }

  it "borrows a book successfully" do
    borrow = described_class.new(user, book).call
    expect(borrow).to be_persisted
  end

  it "prevents borrowing same book twice" do
    described_class.new(user, book).call

    expect {
      described_class.new(user, book).call
    }.to raise_error(BorrowBookService::AlreadyBorrowedError, "Already borrowed by #{user.email}")
  end

  it "prevents borrowing when no copies available" do
    create(:borrow, book: book)

    expect {
      described_class.new(user, book).call
    }.to raise_error(BorrowBookService::NoCopiesAvailableError, "No copies available")
  end
end
