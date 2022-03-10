module Helpers
    def welcome_message
      puts "#" * 36
      puts "#      Welcome to Expensable      #"
      puts "#" * 36
    end
  
    def get_with_options(options)
      input = ""
  
      loop do
        puts options.join(" | ")
        print "> "
        input = gets.chomp
  
        break if options.include?(input)
  
        puts "Invalid Option"
      end
  
      input
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

    # def get_string_con_regex()
    #   unless regex.nil?
    #     until regex.match?(label)
    #       puts "#{label} incorrecto" 
    #       puts "Password de 6 letras" if label=="Password"#Password de 6 letras 
    #       print "#{label}: "
    #       gets.chomp
    #     end
    #   end
    # end
  
    def login_form
      email = get_string("Email")
      password = get_string("Password")
        { email: email, password: password }
    end
  
    def check_string_regex(input,texto,rpta,regex)
      until input =~ /\w+@\w+.[a-z]{2,3}/
        puts texto
        input = get_string("Email")        
      end 
    end

    def user_data
      email = get_string("Email")
      check_string_regex(email,"Email","Invalid format corre@",/\w+@\w+.[a-z]{2,3}/)

      password = get_string("Password")
      check_string_regex(password,"Password","Minimum 6 characters @",/\w{6}/)


      first_name = get_string("First name")
      check_string_regex(first_name,"First name","No dejar en blanco",/\w+/)

      last_name = get_string("Last name")
      check_string_regex(last_name,"Last name","No dejar en blanco",/\w+/)


      phone = get_string("Phone")
      until phone =~ /\d{9}/ || phone =~ /[+]?[5]?[1]?\s\d{9}/
        puts "Formato incorrecto, usar formato +51 123456789 o 123456789"
        phone = get_string("Phone")
      end 


      { email: email, password: password, first_name: first_name, last_name: last_name, phone: phone }
    end
  end