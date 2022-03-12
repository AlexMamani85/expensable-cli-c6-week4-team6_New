module Helpers
  def welcome_message
    puts "#" * 36
    puts "#      Welcome to Expensable      #"
    puts "#" * 36
  end

  def get_with_options(options, options_shows: [], default: nil)
    action = ""
    id = nil
    
    loop do
      puts options_shows.empty? ? options.join(" | ") : options_shows.join(" | ")
      print "> "
      action, id = gets.chomp.split
      action ||= ""
      break if options.include?(action) || (action.empty? && !default.nil?)

      puts "Invalid Options!"
    end

    action.empty? ? [default, id] : [action, id]    
  end

  def login_menu
    get_with_options(["login", "create_user", "exit" ])
  end

  def categories_menu
    get_with_options(["create", "show", "update", "delete", "add-to", "toggle", "next", "prev", "logout"], 
      options_shows: ["create", "show ID", "update ID", "delete ID", "add-to ID", "toggle", "next", "prev", "logout"])
  end

  def exit_message
    puts "#" * 36
    puts "#    Thanks for using Expensable   #"
    puts "#" * 36
  end

  def get_string(label)
    print "#{label}: "
    gets.chomp
  end

  def login_form
    email = ""
    password = ""
    while email.empty?
      email = get_string("Email")
      puts "Cannot be blank" if email.empty?
    end 
    while password.empty?
      password = get_string("Password")
      puts "Cannot be blank" if password.empty?
    end
    { email: email, password: password }
  end

  def user_data
  
    email = get_string("Email")
    until email =~ /\w+@\w+.[a-z]{2,3}/
      puts "Invalid format"
      email = get_string("Email")        
    end 

    password = get_string("Password")
    until password =~ /\w{6}/
      puts "Minimum 6 characters"
      password = get_string("Password")
    end 

    first_name = get_string("First name")
    last_name = get_string("Last name")
    
    phone = get_string("Phone")
    until phone =~ /\d{9}/ || phone =~ /[+]?[5]?[1]?\s\d{9}/
      puts "Required format: +51 123456789 o 123456789"
      phone = get_string("Phone")
    end

    { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone }
  end

  def category_form
    name = ""
    transaction_type = ""
    while name.empty?
      name = get_string("Name")
      puts "Cannot be blank" if name.empty?
    end 
    
    until transaction_type == "expense" || transaction_type == "income"
      transaction_type = get_string("transaction_type")
      puts "Only income or expense" unless transaction_type == "expense" || transaction_type == "income"
    end
    { name: name, transaction_type: transaction_type }
    
  end


end