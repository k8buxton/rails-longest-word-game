require "open-uri"

class GamesController < ApplicationController

  VOWELS = %w(A E I O U)

  def new
    @grid = Array.new(7) { (('A'..'Z').to_a - VOWELS).sample }
    @grid += Array.new(3) { VOWELS.sample }
    @grid.shuffle
  end

  def score
    @guess = params[:game]
    @grid = params[:grid]
    if guess_check(@guess, @grid)
      if letters_present(@guess, @grid)
        if dictionary_check(@guess)
          @message = "Congratulations, #{@guess} is a valid English word!"
        else
          @message = "Sorry but #{@guess} does not seen to be a valid English word!"
        end
      else
        @message = "Sorry but #{@guess} cannot be built out of #{params[:grid]}!"
      end
    else
      @message = "Sorry your word is too long!"
    end
  end

  def guess_check(argument1, argument2)
    if argument1.split("").count <= argument2.split.count
      true
    else
      false
    end
  end

  def letters_present(word1, word2)
    word1.chars.all? { |letter| word1.count(letter) <= word2.count(letter) }
  end

  def dictionary_check(argument)
    url = "https://wagon-dictionary.herokuapp.com/#{argument}"
    response = JSON.parse(open(url).read)
    response['found']
  end

end
