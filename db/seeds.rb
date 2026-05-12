# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
member = User.find_or_initialize_by(email: "user@books.com")
member.assign_attributes(password: "password123", password_confirmation: "password123")
member.save!

books_data = [
  { title: "The Pragmatic Programmer", author: "David Thomas", genre: "Technical", total_copies: 3 },
  { title: "Clean Code", author: "Robert C. Martin", genre: "Technical", total_copies: 2 },
  { title: "1984", author: "George Orwell", genre: "Fiction", total_copies: 4 },
  { title: "Sapiens", author: "Yuval Noah Harari", genre: "History", total_copies: 2 }
]

books_data.each do |attrs|
  Book.find_or_create_by!(title: attrs[:title]) do |b|
    b.assign_attributes(attrs)
  end
end
