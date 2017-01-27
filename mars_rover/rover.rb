#!/bin/ruby
#
# Mars Rover
# By Rahul Ghose
# 2017-01-25
# https://gist.github.com/AnkurGel/d4eb058e1f4fd5c76255671327db70a4
#
# Assumptions:
# 1. rovers *cannot* cross boundaries
# 2. rovers can occupy a position already occupied by other rover(s)
#

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

class Map
  def initialize(x=0,y=0)
    @width = Integer(x)
    @height = Integer(y)
  end

  def height
    @height
  end

  def width
    @width
  end
end

class Rover
  private
  @map
  @position
  @orientation

  def set_position(x,y)
    @position = { :x => x, :y => y }
  end

  def set_orientation(o)
    @orientation = o
  end

  public
  def initialize(x=0, y=0, o="N", width=100, height=100)
    set_position(x,y)
    set_orientation(o)
    @map = Map.new(width, height)
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

  # Move the rover, keeping the borders in mind
  def move_rover()
    puts  "DEBUG: moving: #{@orientation}" if DEBUG
    case @orientation
      when DIRECTION_EAST
        @position[:x] += 1 if @position[:x] < @map.width
      when DIRECTION_WEST
        @position[:x] -= 1 if @position[:x] > 0
      when DIRECTION_NORTH
        @position[:y] += 1 if @position[:y] < @map.height
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
    r = Rover.new(Integer(x),Integer(y),o, max_x, max_y)
    moves = gets.chomp
    moves.each_char do |move|
      r.run(move)
    end
    puts "DEBUG: #{r.show()}" if DEBUG
    rovers.push(r)
  end
  rovers.each { |r|
    puts r.show()
  }
end

main()