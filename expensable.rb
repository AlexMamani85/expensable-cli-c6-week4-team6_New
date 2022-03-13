require "terminal-table"
require_relative "helpers"
require_relative 'sessions'
require 'date'
require_relative 'categories'

class ExpensableApp
  include Helpers

  def intialize
   
    @user = nil
    @categories_month = []
    @trash = false
    @categories = []
  end

  def start
    @day = Date.new(2021,12,1)
    @transaction_type = "expense"
    welcome_message
    action = ""
    
  
    until action == "exit"
      action, _rest = login_menu
    begin
      case action
      when "login"
        login
      when "create_user"
        create_user
      when "exit"
        exit_message
      end
    rescue HTTParty::ResponseError => error
      parsed_error = JSON.parse(error.message, symbolize_names: true)
      puts parsed_error[:errors]
      welcome_message
    end
    end 
    
  end

  def create_user
    credentials = user_data
    @user = Sessions.signup(credentials)
    puts "Welcome to Expensable #{@user[:first_name].downcase.capitalize} #{@user[:last_name].downcase.capitalize}"
    categories_page
  end
  
  def login

    credentials = login_form
    @user = Sessions.login(credentials)
    puts "Welcome back #{@user[:first_name].downcase.capitalize} #{@user[:last_name].downcase.capitalize}"
    categories_page
  end

  def logout
    @user = Sessions.logout(@user[:token])
    welcome_message
  end

  def categories_page
   @categories = Categories.categories(@user[:token])
    action = ""

    until action == "logout"  
      puts expenses_table
      action, id = categories_menu

      begin
        case action
        when "create" 
          create_category
        when "show"
          show_category(id.to_i)
        when "update"
          update_category(id.to_i)
        when "delete" # Llamamos a nuestro menu trash
          delete_category_id(id.to_i)
        when "add-to"
          puts "add something to an id"
        when "toggle"
          toggle_category(id.to_i)
        when "next"
          next_month
        when "prev"
          prev_month
        when "logout" 
          logout
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end

  def create_category
    data = category_form #(name, transaction_type)
    new_category = Categories.create_categories(@user[:token], data)
    @categories << new_category

  end

  def delete_category_id(id)
    deleted_note = Categories.destroy(@user[:token], id)
    founded_note = @categories.find{ |note| note[:id] == id}
    if deleted_note
      founded_note.update(deleted_note)
    else
      @categories.delete(founded_note)
    end
  end

  def show_category(id)
    rows=[]
    titulo=""
    @categories.map do |el| 
      el[:transactions].map do |it| 
      # pp el [:transactions][:id]
      # pp a[:date]
      # pp a[:amount]
      # pp a[:notes]
        rows << [it[:id], it[:date], it[:amount], it[:notes] ] if el[:id]==id 
        titulo= el[:name] if el[:id]==id   
      end

    end
    table = Terminal::Table.new
    table.title = "#{titulo} \n#{@day}"
    table.headings = ['ID', 'Date', 'Amount', 'Notes']
    table.rows = rows
    table.style = { :border => :unicode }
    puts table

    

  end



  def update_category(id)
    data = category_form
    updated_category = Categories.update(@user[:token], id, data)
  
      founded_category = @categories.find{ |el| el[:id] == id}
      updated_category.delete(:transactions)
      founded_category.update(updated_category)
  end

  def toggle_category(id)
    found_note = @notes.find{ |note| note[:id] == id}
    note_data = { pinned: !found_note[:pinned] } # Cambiamos el pinned actual por su negacion para efectuar toogle 

    updated_note = Categories.update(@user[:token], id, note_data)
    found_note.update(updated_note)
  end

  def next_month
    @day = @day >> 1
  end

  def prev_month
    @day = @day >> -1
  end
  
  def expenses_table
    table = Terminal::Table.new
    table.title = "Expenses\n #{@day.strftime("%B %Y")}"
    table.headings = ['ID', 'Category', 'Total']
    @categories_month = []
    @categories.each do |cat|
      # m = 0
      suma=0
      if cat[:transaction_type] == @transaction_type
        cat[:transactions].each do |transaction|
          suma+=transaction[:amount]
        end
        @categories_month.push(id: cat[:id],name: cat[:name],suma: suma)
      end
    end

    table.rows = @categories_month.map do |cat|
      [ cat[:id], cat[:name], cat[:suma]] 
    end
    table.style = { :border => :unicode }
    table
  end

end

app = ExpensableApp.new
app.start