require "json"

module Requester
  def select_main_menu_action
    # prompt the user for the "random | scores | exit" actions
    options = %w[random scores exit]
    gets_option(options)
  end

  def will_save?(_score)
    # ask the user to save the score
    print "Do you want to save your score? y/n "
    # grab user input
    options = %w[y n]
    action = gets.chomp.strip.downcase
    until options.include?(action)
      print "Choose a correct alternative: y/n ".red
      action = gets.chomp.strip.downcase
    end
    case action
    when "y" then saveif
    when "n" then @score = 0
    end
  end

  def saveif
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
    puts "Type the name to assign to the score:"
    print "> "
    name = gets.chomp
    name = name == "" ? "Anonymous" : name
    data = { score: @score, name: name }
    save(data)
  end

  def get_number(length)
    # prompt the user for a number between 1 and the maximum number of options
    print "> "
    election = gets.chomp.to_i
    until election < length && election.positive?
      puts "Invalid option".red
      print "> "
      election = gets.chomp.to_i
    end
    election
  end

  def gets_option(options)
    # prompt for an input
    puts options.join(" | ")
    print "> "
    input = gets.chomp.strip.downcase
    puts ""
    # keep going until the user gives a valid option
    until options.include?(input)
      puts "Invalid option".red
      print "> "
      input = gets.chomp.strip.downcase
    end
    input
  end
end
