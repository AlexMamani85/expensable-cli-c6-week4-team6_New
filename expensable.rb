require "terminal-table"
require_relative "helpers"
require_relative "sessions"
require "date"
require_relative "categories"
require "colorize"
require_relative "show"

class ExpensableApp
  include Helpers
  include Colorize

  def intialize
    @user = nil
    @categories_month = []
    @trash = false
    @categories = []
  end

  def start
    @day = Date.new(2021, 11, 1)
    @transaction_type = "expense"
    welcome_message
    action = ""

    until action == "exit"
      action, _rest = login_menu
      begin
        case action
        when "login" then login
        when "create_user" then create_user
        when "exit" then exit_message
        end
      rescue HTTParty::ResponseError => e
        parsed_error = JSON.parse(e.message, symbolize_names: true)
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

    action = ""

    until action == "logout"
      @categories = Categories.categories(@user[:token])
      puts expenses_table
      action, id = categories_menu

      begin
        case action
        when "create" then create_category
        when "show" 
          show = Show.show(@user[:token], id.to_i)
          table_transactions
        when "update" then update_category(id.to_i)
        when "delete" then delete_category_id(id.to_i)
        when "add-to" then add_transaction_id(id.to_i)
        when "toggle" then toggle
        when "next" then next_month
        when "prev" then prev_month
        when "logout" then logout
        end
      rescue HTTParty::ResponseError => e
        parsed_error = JSON.parse(e.message, symbolize_names: true)
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

    founded_category = @categories.find { |el| el[:id] == id }
    updated_category.delete(:transactions)
    founded_category.update(updated_category)
  end

  def add_transaction_id(id)
    data = transaction_form
    Categories.add_transaction(@user[:token], data, id)
  end
  
  def add_transaction
    data = transaction_form
    Show.add_show(@user[:token], data)
    
  end

  def toggle
    @transaction_type = @transaction_type == "expense" ? "income" : "expense"
    # @transaction_type
  end

  def next_month
    @day = @day >> 1
  end

  def prev_month
    @day = @day >> -1
  end

  def table_transactions
    option=""
    until option=="back"
      puts show_table
      option, id = transaction_menu 
      case option
      when "add" then add_transaction
      when "update" then update_category_transactions(id.to_i)
      when "delete" then delete_transacctions(id.to_i)
      when "next" then next_month 
      when "prev" then prev_month 
      end
    end
  end

  def delete_transacctions(id)
    Show.delete_show(@user[:token], id)
  end

  def update_category_transactions(id)
    data = transaction_form
    Show.update_transaction(@user[:token], id, data)
  end

  def expenses_table
    table = Terminal::Table.new
    table.title = (if @transaction_type == "expense"
                     "Expenses\n #{@day.strftime('%B %Y')}"
                   else
                     "Incomes\n #{@day.strftime('%B %Y')}"
                   end)
    table.headings = ["ID", "Category", "Total"]
    categories_month = give_categories_month
    table.rows = categories_month.map do |note|
      [note[:id], note[:name], note[:amount]]
    end
    table.style = { border: :unicode }
    table
  end

  def give_categories_month
    categories_month = []
    @categories.each do |note|
      next unless note[:transaction_type] == @transaction_type

      amount = 0
      note[:transactions].each do |transaction|
        amount += transaction[:amount] if transaction[:date].split("-")[1] == @day.strftime("%m")
      end
      categories_month.push({ id: note[:id].to_s, name: note[:name].to_s,
                              amount: amount.to_s })
    end
    categories_month
  end

  def show_table
    array = [] 
    
    @show[:transactions].each  { |ele| array << ele if ele[:date].split("-")[1] == @day.strftime("%m") }
    
    table = Terminal::Table.new
    table.title = "#{@show[:name]}\n #{@day.strftime('%B %Y')}"
    table.headings = ['ID', 'Date', 'Amount', 'Notes']
    table.rows = array.map do |note|
      [ note[:id], note[:date], note[:amount], note[:notes]]
    end
    table.style = { :border => :unicode }
    table
  end

end

app = ExpensableApp.new
app.start

