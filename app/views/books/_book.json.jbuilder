json.extract! book, :id, :title, :author, :genre, :total_copies
json.status book.status
json.url book_url(book, format: :json)
