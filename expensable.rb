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
    @day = Date.new(2021,11,1)
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
          puts "show something"
        when "update"
          update_category(id.to_i)
        when "delete" # Llamamos a nuestro menu trash
          delete_category_id(id.to_i)
        when "add-to"
          puts "add something to an id"
        when "toggle"
          toggle
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
    data = category_form
    new_category = Categories.create_categories(@user[:token], data)
    @categories_month << new_category
  end
  
  def delete_category_id(id)
    Categories.delete_category(@user[:token], id)
  end

  def update_category(id)
    data = category_form
    updated_category = Categories.update(@user[:token], id, data)
  
      founded_category = @categories.find{ |el| el[:id] == id}
      updated_category.delete(:transactions)
      founded_category.update(updated_category)
  end

  def toggle
    @transaction_type == "expense" ? @transaction_type = "income" : @transaction_type = "expense"
    #@transaction_type
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
    @categories.each do |note|
      m = 0
      if note[:transaction_type] == @transaction_type
        note[:transactions].each do |transaction|
          if transaction[:date].split("-")[1] == @day.strftime("%m") && m == 0
          @categories_month.push(note)
          m = 1
          end
       end
      end
    end
    table.rows = @categories_month.map do |note|
      [ note[:id], note[:name], note[:transactions].map { |el| el[:amount] }.sum] 
    end
    table.style = { :border => :unicode }
    table
  end

end

app = ExpensableApp.new
app.start