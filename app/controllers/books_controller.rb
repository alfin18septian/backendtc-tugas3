class BooksController < ApplicationController

    rescue_from ActiveRecord::RecordNotFound, with: :notFound

    def index
        books = Book.all
        render json: {
            result: true, 
            users: custom_books_data(books)
        }, status: :ok
    end
    
    def create
        author = Author.create!(author_params)
        book = Book.new(book_params.merge(author_id: author.id))
        if book.save
            render json: {status: true, message: "Create Secces", data: custom_book_data(book)}
        else
            render json: { result: false, massage: book.errors }, status: :unprocessable_entity
        end
    end
    
    def show
        book = Book.find(params[:id])
        render json: { 
            result: true, 
            data: custom_book_data(book)
        }, status: :ok
    end

    def update
        book = Book.find(params[:id])
        if book.update(book_params)
            render json: { 
                result: true, 
                message: "Update Success", 
                value: custom_book_data(book)
            }, status: :ok
        else 
            render json: { result: false, message: book.errors}, status: :unprocessable_entity
        end
    end
    

    def destroy
        book = Book.find(params[:id])
        if book.destroy
            render json: { result: true, message: "Delete Success" }, status: :ok
        else
            render json: { result: false, message: book.errors }, status: :unprocessable_entity
        end
    end

    private

    def book_params
        params.require(:book).permit(:title)
    end

    def author_params
        params.require(:author).permit(:first_name, :last_name, :age)
    end

    def custom_book_data(book)
        {
            id: book.id,
            title: book.title,
            author_name: "#{book.author.first_name} #{book.author.last_name}",
            author_age: book.author.age
        }
    end

    def custom_books_data(books)
        books.map do |book|
            {
                id: book.id,
                title: book.title,
                author_name: "#{book.author.first_name} #{book.author.last_name}",
                author_age: book.author.age
            }
        end
    end
    
    
    def notFound
        render json: {
            result: false,
            message: "Data Not Found"
        }, status: :not_found
    end
end
