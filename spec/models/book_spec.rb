require 'rails_helper'

RSpec.describe Book, type: :model do
  it "is valid with valid attributes" do
    expect(build(:book)).to be_valid
  end
  it "is invalid with missing attributes" do
    expect(build(:book, title: nil)).not_to be_valid
  end
end
