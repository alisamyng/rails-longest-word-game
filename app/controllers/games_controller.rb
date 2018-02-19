require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    letters_array = []
    10.times do |a|
      letters_array << ("a"..."z").to_a.sample
    end
    @letters = letters_array
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    if english_word? && container_in_grid?
      @reply = @word.length
    elsif !(english_word?) && container_in_grid?
      @reply = "Sorry but #{@word} is not a valid word"
    else
      @reply = "Sorry but #{@word} could not be built out of #{@letters}"
    end
  end

  def english_word?
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    wagon_dictionary = open(url).read
    word_correct = JSON.parse(wagon_dictionary)
    return word_correct["found"]
  end

  def container_in_grid?
    @word.split("").all? do |letter|
      @word.count(letter) <= @letters.count(letter)
    end
  end
end
