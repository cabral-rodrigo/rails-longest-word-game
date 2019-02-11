require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @time_start = Time.now
    @grid = []
    (0...10).each do |i|
      @grid[i] = ('A'..'Z').to_a[rand(26)]
    end
  end

  def score
    @word = params[:word]
    letters = params[:letters].split('')
    start_time = params[:timestart].to_datetime
    end_time = Time.now.to_datetime

    @results = run_game(@word, letters, start_time, end_time)
  end

  private

  def run_game(word, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  result = { time: (end_time.to_time.to_i - start_time.to_time.to_i).abs, score: 0, message: "Well done #{word} is a valid word!" }
  array2 = word.upcase.split(//)
  if !english_word?(word)
    result[:message] = "You loose! #{word} Not an english word"
  elsif !difference_between_arrays(array2, grid)
    result[:message] = "You loose! #{word} Not in the grid"
  else result[:score] = word.length * 1000 / result[:time]
  end
    return result
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_parse = open(url).read
    valid_word = JSON.parse(word_parse)
    return valid_word['found']
  end

  def difference_between_arrays(array2, array1)
    difference = array2.dup
    array1.each do |element|
      if (index = difference.index(element))
        difference.delete_at(index)
      end
    end
      return difference.size.zero?
  end
end
