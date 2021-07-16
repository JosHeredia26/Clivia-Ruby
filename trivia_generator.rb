# do not forget to require your gem dependencies
require "htmlentities"
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
    end
    puts "Well done! Your score is #{@score}"
    puts "--------------------------------------------------"
    puts "Do you want to save your score? y/n "
  end

  def ask_questions(questions)
    # ask each question
    puts "Question: #{@decoder.decode(questions[:question])}"
    @alternatives = questions[:incorrect_answers].push(questions[:correct_answer]).shuffle
    @alternatives.each_with_index.map do |e, index|
      puts "#{index + 1}. #{@decoder.decode(e)}"
    end
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
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
