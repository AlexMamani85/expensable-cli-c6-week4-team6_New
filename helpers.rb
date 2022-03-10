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
  # def get_with_options(options)
  #   input = ""

  #   loop do
  #     puts options.join(" | ")
  #     print "> "
  #     input = gets.chomp

  #     break if options.include?(input)

  #     puts "Invalid Option"
  #   end

  #   input
  # end

  def exit_message
    puts "#" * 36
    puts "#    Thanks for using Expensable   #"
    puts "#" * 36
  end

  def get_string(label, required: false)
    input = ""

    loop do
      print "#{label}: "
      input = gets.chomp
      break unless input.empty? && required

      puts "Can't be blank"
    end

    input
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
  
  def update_category_form(id)
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
       
    # while transaction_type.empty?
    #   transaction_type = get_string("transaction_type")
    #   puts "Cannot be blank" if transaction_type.empty?
    # end
    { id: id, name: name, transaction_type: transaction_type}

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
       
    # while transaction_type.empty?
    #   transaction_type = get_string("transaction_type")
    #   puts "Cannot be blank" if transaction_type.empty?
    # end
    { name: name, transaction_type: transaction_type }
    
  end
end


  # def user_data
 

  # email = get_string("Email")
  # check_string_regex(email,"Email","Invalid format corre@",/\w+@\w+.[a-z]{2,3}/)

  # password = get_string("Password")
  # check_string_regex(password,"Password","Minimum 6 characters @",/\w{6}/)


  # first_name = get_string("First name")
  # check_string_regex(first_name,"First name","No dejar en blanco",/\w+/)

  # last_name = get_string("Last name")
  # check_string_regex(last_name,"Last name","No dejar en blanco",/\w+/)


  # phone = get_string("Phone")
  # until phone =~ /\d{9}/ || phone =~ /[+]?[5]?[1]?\s\d{9}/
  #   puts "Formato incorrecto, usar formato +51 123456789 o 123456789"
  #   phone = get_string("Phone")
  # end 
#   { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone }
# end