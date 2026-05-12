## Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

## Test credentials (from seeds)

| Email                  | Password    |
|------------------------|------------|
| `user@books.com` | `password123` |


## Test books (from seeds)

| Title | Author | Genre | Total Copies |
|-------|--------|-------|--------------|
| The Pragmatic Programmer | David Thomas | Technical | 3 |
| Clean Code | Robert C. Martin | Technical | 2 |
| 1984 | George Orwell | Fiction | 4 |
| Sapiens | Yuval Noah Harari | History | 2 |


## Fetching the books

```bash
$ sudo apt  install jq # to see the formated output
$ curl --header "Content-Type: application/json" --request GET http://localhost:3000/books.json | jq
[
  {
    "id": 1,
    "title": "The Pragmatic Programmer",
    "author": "David Thomas",
    "genre": "Technical",
    "total_copies": 3,
    "status": "available",
    "url": "http://localhost:3000/books/1.json"
  },
  {
    "id": 2,
    "title": "Clean Code",
    "author": "Robert C. Martin",
    "genre": "Technical",
    "total_copies": 2,
    "status": "available",
    "url": "http://localhost:3000/books/2.json"
  },
  {
    "id": 3,
    "title": "1984",
    "author": "George Orwell",
    "genre": "Fiction",
    "total_copies": 4,
    "status": "available",
    "url": "http://localhost:3000/books/3.json"
  },
  {
    "id": 4,
    "title": "Sapiens",
    "author": "Yuval Noah Harari",
    "genre": "History",
    "total_copies": 2,
    "status": "available",
    "url": "http://localhost:3000/books/4.json"
  }
]

```

## Borrowing the book

```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{ "email": "user@books.com" }' \
  http://localhost:3000/books/1/reserve
```

## Listing the borrowed books

```bash
$ curl --header "Content-Type: application/json" --request GET http://localhost:3000/books/borrows.json | jq

[
  {
    "id": 3,
    "user_id": 1,
    "book_id": 3,
    "borrowed_at": "2026-05-12T22:27:29.535Z",
    "due_date": "2026-05-26T22:27:29.535Z",
    "returned_at": null
  },
  {
    "id": 2,
    "user_id": 1,
    "book_id": 2,
    "borrowed_at": "2026-05-12T22:27:16.023Z",
    "due_date": "2026-05-26T22:27:16.023Z",
    "returned_at": null
  },
  {
    "id": 1,
    "user_id": 1,
    "book_id": 1,
    "borrowed_at": "2026-05-12T21:24:18.295Z",
    "due_date": "2026-05-26T21:24:18.295Z",
    "returned_at": null
  }
]
```