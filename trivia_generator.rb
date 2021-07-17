# do not forget to require your gem dependencies
require "htmlentities"
require "json"
# do not forget to require_relative your local dependencies
require_relative "presenter"
require_relative "requester"
require_relative "trivia_services"

class TriviaGenerator
  # maybe we need to include a couple of modules?
  include Presenter
  include Requester

  def initialize
    # we need to initialize a couple of properties here
    @questions = []
    @decoder = HTMLEntities.new
    @score = 0
    jsonstring = File.read("scores.json")
    @report = jsonstring.empty? ? [] : JSON.parse(jsonstring)
  end

  def start
    # welcome message
    print_welcome
    # prompt the user for an action
    action = select_main_menu_action
    # keep going until the user types exit
    until action == "exit"
      case action
      when "random" then random_trivia
      when "scores" then print_scores
      end
      print_welcome
      action = select_main_menu_action
    end
  end

  def random_trivia
    # load the questions from the api
    # questions are loaded, then let's ask them
    load_questions.each do |questions|
      puts "Category: #{@decoder.decode(questions[:category])} | Difficulty: #{@decoder.decode(questions[:difficulty])}"
      ask_questions(questions)
      puts ""
    end
    print_score(@score)
    puts "-" * 50
    will_save?(@score)
  end

  def ask_questions(questions)
    # ask each question
    correct_index = 0
    selected_alternative = ""
    puts "Question: #{@decoder.decode(questions[:question])}"
    @alternatives = questions[:incorrect_answers].push(questions[:correct_answer]).shuffle
    @alternatives.each_with_index.map do |e, index|
      puts "#{index + 1}. #{@decoder.decode(e)}"
      correct_index = index + 1 if e == questions[:correct_answer]
    end
    selection = get_number(questions[:incorrect_answers].length + 1)
    @alternatives.each_with_index.map do |e, index|
      selected_alternative = e if selection == index + 1
    end
    mmm(selection, correct_index, selected_alternative, questions)
    # once the questions end, show user's score and promp to save it
  end

  def mmm(selection, correct_index, selected_alternative, questions)
    # if response is correct, put a correct message and increase score
    if selection == correct_index
      puts "#{@decoder.decode(selected_alternative)}... Correct!"
      @score += 10
    # if response is incorrect, put an incorrect message, and which was the correct answer
    else
      puts "#{selected_alternative}... Incorrect!"
      puts "The correct answer was: #{questions[:correct_answer]}"
    end
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions
    # ask the api for a random set of questions
    @questions = TriviaAPI.index[:results]
    # parse_questions
  end

  def parse_questions
    # questions came with an unexpected structure, clean them to make it usable for our purposes
  end

  def print_scores
    # print the scores sorted from top to bottom
  end
end

trivia = TriviaGenerator.new
trivia.start
