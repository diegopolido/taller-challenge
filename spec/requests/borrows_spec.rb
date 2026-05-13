require "rails_helper"

RSpec.describe "Borrows", type: :request do
  describe "GET /books/borrows" do
    it "returns http success" do
      get books_borrows_path
      expect(response).to have_http_status(:success)
    end

    it "lists borrows ordered by borrowed_at desc" do
      user = create(:user)
      older = create(:borrow, user: user, book: create(:book), borrowed_at: 2.days.ago)
      newer = create(:borrow, user: user, book: create(:book), borrowed_at: 1.day.ago)

      get books_borrows_path

      expect(assigns(:borrows).first).to eq(newer)
      expect(assigns(:borrows).last).to eq(older)
    end
  end

  describe "GET /books/reserve" do
    it "returns http success" do
      get books_reserve_path
      expect(response).to have_http_status(:success)
    end

    it "assigns all books" do
      books = create_list(:book, 3)
      get books_reserve_path
      expect(assigns(:books)).to match_array(books)
    end
  end

  describe "POST /books/:book_id/reserve" do
    let(:book) { create(:book) }
    let(:user) { create(:user) }

    context "with valid params" do
      context "with HTML request" do
        it "creates a borrow and redirects" do
          post "/books/#{book.id}/reserve", params: { email: user.email }
          expect(response).to redirect_to(books_reserve_path)
          expect(flash[:notice]).to eq("Book successfully reserved")
        end
      end

      context "with JSON request" do
        it "creates a borrow and returns JSON" do
          post "/books/#{book.id}/reserve.json",
              params: { email: user.email },
              headers: { "Accept" => "application/json" }

          expect(response).to have_http_status(:created)
          expect(response.parsed_body["id"]).to be_present
        end
      end
    end

    context "when the book does not exist" do
      context "with HTML request" do
        it "redirects with an alert" do
          post "/books/999999/reserve", params: { email: user.email }
          expect(response).to redirect_to(books_reserve_path)
          expect(flash[:alert]).to eq("Book not found")
        end
      end

      context "with JSON request" do
        it "returns 404 JSON" do
          post "/books/999999/reserve",
              params: { email: user.email },
              headers: { "Accept" => "application/json" }

          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body["error"]).to eq("Book not found")
        end
      end
    end

    context "when the user does not exist" do
      context "with HTML request" do
        it "redirects with an alert" do
          post "/books/#{book.id}/reserve", params: { email: "notfound@example.com" }
          expect(response).to redirect_to(books_reserve_path)
          expect(flash[:alert]).to eq("User not found")
        end
      end

      context "with JSON request" do
        it "returns 404 JSON" do
          post "/books/#{book.id}/reserve",
              params: { email: "notfound@example.com" },
              headers: { "Accept" => "application/json" }

          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body["error"]).to eq("User not found")
        end
      end
    end

    context "when the book is already borrowed by the user" do
      before { create(:borrow, user: user, book: book, returned_at: nil) }

      context "with HTML request" do
        it "redirects with an alert" do
          post "/books/#{book.id}/reserve", params: { email: user.email }
          expect(response).to redirect_to(books_reserve_path)
          expect(flash[:alert]).to include("Already borrowed by")
        end
      end

      context "with JSON request" do
        it "returns an error in JSON" do
          post "/books/#{book.id}/reserve",
              params: { email: user.email },
              headers: { "Accept" => "application/json" }

          expect(response.parsed_body["error"]).to include("Already borrowed by")
        end
      end
    end

    context "when there are no copies available" do
      before do
        book.update(total_copies: 1)
        create(:borrow, book: book, returned_at: nil)
      end

      context "with HTML request" do
        it "redirects with an alert" do
          post "/books/#{book.id}/reserve", params: { email: user.email }
          expect(response).to redirect_to(books_reserve_path)
          expect(flash[:alert]).to eq("No copies available")
        end
      end

      context "with JSON request" do
        it "returns an error in JSON" do
          post "/books/#{book.id}/reserve",
              params: { email: user.email },
              headers: { "Accept" => "application/json" }

          expect(response.parsed_body["error"]).to eq("No copies available")
        end
      end
    end
  end
end
