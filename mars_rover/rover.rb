#!/bin/ruby
#
# Mars Rover
# By Rahul Ghose
# 2017-01-25
# https://gist.github.com/AnkurGel/d4eb058e1f4fd5c76255671327db70a4

# directions in anti-clockwise order
DIRECTIONS = [ "E", "N", "W", "S" ]
DIRECTION_EAST = "E"
DIRECTION_WEST = "W"
DIRECTION_NORTH = "N"
DIRECTION_SOUTH = "S"
LEFT = 0
RIGHT = 1
LR = [ "L", "R" ]

DEBUG = false

class Rover
  private
  @position
  @orientation

  def set_position(x,y)
    @position = { :x => x, :y => y }
  end

  def set_orientation(o)
    @orientation = o
  end

  public
  def initialize(x=0, y=0, o="N")
    set_position(x,y)
    set_orientation(o)
  end

  def show()
    "#{@position[:x]} #{@position[:y]} #{@orientation}"
  end

  def rotate(direction)
    if direction == LEFT
      @orientation = DIRECTIONS[(DIRECTIONS.index(@orientation)+DIRECTIONS.length+1)%DIRECTIONS.length]
    elsif direction == RIGHT
      @orientation = DIRECTIONS[(DIRECTIONS.index(@orientation)+DIRECTIONS.length-1)%DIRECTIONS.length]
    else
      throw Exception.new("Invalid direction for rover: #{direction}")
    end
  end

  def move_rover()
    puts  "DEBUG: moving: #{@orientation}" if DEBUG
    case @orientation
      when DIRECTION_EAST
        @position[:x] += 1
      when DIRECTION_WEST
        @position[:x] -= 1 if @position[:x] > 0
      when DIRECTION_NORTH
        @position[:y] += 1
      when DIRECTION_SOUTH
        @position[:y] -= 1 if @position[:y] > 0
    end
    puts  "DEBUG: position after move: #{@position}" if DEBUG
  end

  def run(spec)
    case spec
      when LR[LEFT]
        rotate(LEFT)
      when LR[RIGHT]
        rotate(RIGHT)
      when "M"
        move_rover()
      else
    end
  end
end

def main()
  max_x, max_y = gets.chomp.split()
  rovers = []
  while line=gets
    input_array = line.split()
    if input_array.length == 0
      break
    end
    x,y,o = input_array
    r = Rover.new(Integer(x),Integer(y),o)
    moves = gets.chomp
    moves.each_char do |move|
      r.run(move)
    end
    puts "DEBUG: #{r.show()}" if DEBUG
    rovers.push(r)
  end
  puts rovers.length
  rovers.each { |r|
    puts r.show()
  }
end

main()