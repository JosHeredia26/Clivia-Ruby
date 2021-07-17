module Presenter
  def print_welcome
    puts [
      "#" * 38,
      "#   Welcome to Validation Clibrary   #",
      "#" * 38
    ].join("\n")
  end

  def print_score(score)
    puts "Well done! Your score is #{score}"
  end
end
