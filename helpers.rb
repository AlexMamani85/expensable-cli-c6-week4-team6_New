module Helpers
  def welcome_message
    puts "#" * 36
    puts "#       " + "Welcome to Expensable" + "      #"
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
    get_with_options(["login", "create_user", "exit"])
  end

  def categories_menu
    get_with_options(["create", "show", "update", "delete", "add-to", "toggle", "next", "prev", "logout"],
                     options_shows: ["create", "show ID", "update ID", "delete ID", "add-to ID", "toggle", "next",
                                     "prev", "logout"])
  end

  def transaction_menu
    get_with_options(["add", "update", "delete", "next", "prev", "back"],
                     options_shows: ["add", "update ID", "delete ID", "next", "prev", "back"])
  end

  def exit_message
    puts "#" * 36
    puts "#    " + "Gracias por usar Expensable" + "   #"
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
    until phone =~ /\d{9}/ || phone =~ /[+]?5?1?\s\d{9}/
      puts "Required format: +51 123456789 o 123456789".light_red
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

    until ["expense", "income"].include?(transaction_type)
      transaction_type = get_string("transaction_type")
      puts "Only income or expense" unless ["expense", "income"].include?(transaction_type)
    end
    { name: name, transaction_type: transaction_type }
  end

  def transaction_form
    amount = ""
    date = ""
    while amount.empty?
      amount = get_string("Amount")
      puts "Cannot be blank" if amount.empty?
    end

    until valid_date?(date)
      date = get_string("Date")
      puts "Required format: YYYY-MM-DD" unless valid_date?(date)
    end
    notes = get_string("Notes")

    { amount: amount.to_i, date: date, notes: notes }
  end

  def valid_date?(date)
    date_format = "%Y-%m-%d"
    DateTime.strptime(date, date_format)
    true
  rescue ArgumentError
    false
  end
end

