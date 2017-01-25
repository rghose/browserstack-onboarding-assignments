#!/bin/ruby
#
# Game of GREED
# By Rahul Ghose

TOTAL_DICE = 5

def get_score(roll)
	uncounted_rolls = roll
	result = { :score => 0, :remaining => [] }
	while not uncounted_rolls.empty?
		entry_size = uncounted_rolls.size
		# Three 1's => 1000 points
		if uncounted_rolls.count(1) >= 3
			3.times do
				uncounted_rolls.delete_if { |x| x == 1 }
			end
			result[:score] += (1000) # update score
			next
		end

		# Three 6's => 600 points
		i = 6
		while i >= 2
			i = i - 1
			if uncounted_rolls.count(i) >= 3
				3.times do
					uncounted_rolls.delete_if { |x| x == i }
				end
				result[:score] += (100 * i) # update score
				next
			end
		end

		if uncounted_rolls.count(1) == 1
			uncounted_rolls.delete(1)
			result[:score] += 100
		end
		if uncounted_rolls.count(5) == 1
			uncounted_rolls.delete(5)
			result[:score] += 50
		end

		if entry_size == uncounted_rolls.size
			break
		end
	end
	result[:remaining] = uncounted_rolls
	return result
end

# returns n random rolls of a six sided dice
def random_rolls(n)
	result = []
	while n > 0
		result.push(Integer((rand()*6)+1))
		n = n-1
	end
	return result
end

def start_game(num_players)
	t = 1
	total_score=[0]*num_players
	while true # loop foreveer (with restrictions)
		last_round = false
		total_score.each { |s|
			if (s >= 3000)
				last_round = true
			end
		}
		puts "Turn #{t}:"
		puts "--------"
		player = 1
		while player <= num_players
			turn_score = 0
			roll = random_rolls(TOTAL_DICE)
			# infinite loop for user response
			while true
				print "Player #{player} rolls: ", roll.join(", "), "\n"
				retval = get_score(roll)
				#print retval
				score = retval[:score]
				turn_score += score
				turn_score = 0 if score == 0
				puts "Score in this round: #{turn_score}"
				puts "Total score: #{total_score[player-1] + turn_score}"
				if score == 0
					print "\n"
					break
				end
				number_of_dice = retval[:remaining].count
				if number_of_dice == 0
					number_of_dice = TOTAL_DICE
				end
				print "Do you want to roll the non-scoring #{number_of_dice} dice? (y/n): "
				response = gets.chomp
				print "\n"
				break if response.downcase != "y"
				roll = random_rolls(number_of_dice)
			end
			# only update score when first-in score is achieved and when player already in
			if turn_score >= 300 || total_score[player-1] > 0
				total_score[player-1] += turn_score # update the actual total after the turn
			end
			player = player + 1
		end
		if last_round
			winner = total_score.each_with_index.max[1] + 1
			print "We have a winner: player #{winner}"
			break
		end
		t=t+1
	end
end

def main()
	players = 0
	if ARGV.count != 1
		print "Please enter the number of players: "
		players = gets.chomp.to_i
	else
		players = ARGV[1].to_i
	end
	if players == 0
		puts "No players"
		exit
	end
	start_game(players)
end

main()
