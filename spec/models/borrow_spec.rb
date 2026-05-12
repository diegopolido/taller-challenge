require 'rails_helper'

RSpec.describe Borrow, type: :model do
  it "is valid" do
    expect(build(:borrow)).to be_valid
  end

  it "belongs to user and book" do
    borrow = create(:borrow)
    expect(borrow.user).to be_present
    expect(borrow.book).to be_present
  end
end
