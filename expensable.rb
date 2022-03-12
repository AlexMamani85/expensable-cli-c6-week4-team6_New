require "terminal-table"
require_relative "helpers"
require_relative 'sessions'
require 'date'
require_relative 'categories'
require_relative 'transactions'

class ExpensableApp
  include Helpers

  def intialize
    @user = nil
    @categories = []
    @trash = false
  end

  def start
    welcome_message
    action = ""
    
  
    until action == "exit"

      action,_rest = login_menu
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
    expense_page
  end
  

  def login
    credentials = login_form
    @user = Sessions.login(credentials)
    puts "Welcome back #{@user[:first_name].downcase.capitalize} #{@user[:last_name].downcase.capitalize}"
    expense_page
  end

  def logout
    @user = Sessions.logout(@user[:token])
    welcome_message
  end

  def expense_page
    @categories = Categories.categories(@user[:token])
    action = ""

    until action == "logout"  
      puts expenses_table

        a=["create","show", "update", "delete","add-to", "toggle", "next", "prev", "logout" ]
        b=["create","show ID", "update ID", "delete ID ","add-to ID", "toggle", "next", "prev", "logout" ]
        action,id= get_with_options(a, options_shows: b)
        
      begin
        case action
        when "create" 
          create_category
        when "show"
          show_category
        when "update"
          update_category(id.to_i)
        when "delete" # Llamamos a nuestro menu trash
          puts "delete something"
        when "add-to"
          puts "add something to an id"
        when "toggle"
          puts "toggle something"
        when "next"
          puts "should go the next month"
        when "prev"
          puts "should go the prev month"
        when "logout" 
          logout
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end


  ### alex
  def update_category(id)
    data = category_form
    return if data.empty? # return explicito para evitar hacer el request si note_data esta vacia
    updated_category = Categories.update(@user[:token], id, data)
    begin
      founded_category = @categories.find{ |el| el[:id] == id}
      updated_category.delete(:transactions)
      p updated_category #### ojo
      founded_category.update(updated_category)
    rescue HTTParty::ResponseError => error
      parsed_error = JSON.parse(error.message, symbolize_names: true)
      puts "xxx"*5
      puts parsed_error[:errors]    
    end
  end
  
  def create_category
    data = category_form
    new_category = Categories.create_categories(@user[:token], data)
    @categories << new_category
  end

  def expenses_table)
    table = Terminal::Table.new
    table.title = "Expenses\n #{Date.today.strftime("%B %Y")}"
    table.headings = ['ID', 'Category', 'Total']
    table.rows = @categories.map do |note|
      pp note
      [ note[:id], note[:name], note[nil]]
    end
    table.style = { :border => :unicode }
    table
  end

  # def notes_to_show
  #   if @trash
  #     sorted_notes.select { |note| note[:deleted_at] } # Seleciona solo las notas que tiene un `deleted_at` con un valor
  #   else
  #     # Dosc to reject => https://apidock.com/ruby/v2_5_5/Array/reject
  #     sorted_notes.reject { |note| note[:deleted_at] } # reject => inverso a `select`
  #   end
  # end

  # def sorted_notes
  #   @notes.sort_by { |note| note[:pinned] ? -1 : 1 }
  #   # Docs to sort_by => https://apidock.com/ruby/Array/sort 
  #   # Ejemplo para el irb 👇
  #   # [true, false, true, true, false, true].sort_by{ |a|  a ? -1 : 1 }
  # end


end

app = ExpensableApp.new
app.start