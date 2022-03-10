require "terminal-table"
require_relative "helpers"
require_relative 'sessions'
require 'date'
require_relative 'categories'

class ExpensableApp
  include Helpers

  def intialize(input_array)

        
    @user = nil
    @categories = []
    @trash = false
  end

  def start
    welcome_message
    action = ""
    
  
    until action == "exit"
      action = get_with_options(["login", "create_user", "exit"])
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

    end
    end 
    
  end

  def create_user
    credentials = user_data ### login_form
    @user = Sessions.signup(credentials)
    expense_page
  end
  
  def login
    credentials = login_form
    # p credentials ### aporte andre
    @user = Sessions.login(credentials)
    puts "Welcome #{@user[:first_name].downcase.capitalize} #{@user[:last_name].downcase.capitalize}"
    expense_page
  end

  def expense_page
    @categories = Categories.categories(@user[:token])
    action = ""

    until action == "logout"  
      puts expenses_table
      action = get_with_options(["create", "show ID", "update ID", "delete ID",
        "add-to ID", "toggle", "next", "prev", "logout"])

      begin
        case action
        when "create" 
          puts "create something"
        when "show ID"
          puts "show something"
        when "update ID"
          puts "update something"
        when "delete ID" # Llamamos a nuestro menu trash
          puts "delete something"
        when "add-to ID"
          puts "add something to an id"
        when "toggle"
          puts "toggle something"
        when "next"
          puts "should go the next month"
        when "prev"
          puts "should go the prev month"
        when "logout" 
          puts "logout" 
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error
      end
    end
  end

  def expenses_table
    table = Terminal::Table.new
    table.title = "Expenses\n #{Date.today.strftime("%B %Y")}"
    table.headings = ['ID', 'Category', 'Total']
    table.rows = @categories.map do |note|
      [ note[:id], note[:name], note[nil]] ### cambio a :name
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