require 'yaml'

class Hangman
	
	def initialize
		@game_over = false
		@body_parts = ["Right arm", "Left arm", "Right leg", "Left leg", "Head", "Torso"]
		select_word
		welcome
		until @game_over == true
			guess
		end
		end_game
	end

	def select_word
		words = []
		lines = File.readlines "5desk.txt"
		lines.each do |line|
			word = line.chomp
			if word.length > 5 && word.length < 12
				words.push(word)
			end
		end

		@random_word = words.sample.downcase
		puts @random_word
		@hidden_word = "-" * @random_word.length
		
	end
	
	def welcome
		puts "Welcome to Hangman!"
	end

	def guess
		puts @hidden_word
		puts "You still have the following body parts: #{@body_parts}"
		puts "Guess a letter! or type 'save' to save the game."
		letter_guess = gets.chomp.downcase

		if letter_guess == 'save'
			save
			exit(0)
		elsif !letter_guess.match(/[[:alpha:]]/)
			puts "That is not a letter. Try again!"
			guess
		elsif letter_guess.length != 1
			puts "You must guess one letter. Try again!"
			guess
		else
			position = 0
			safe = false
			@random_word.split("").each do |x|
				if letter_guess == x
					@hidden_word[position] = letter_guess
					safe = true
				end
				position = position + 1
			end
		end

		if @random_word == @hidden_word
			@game_over = true
			puts "You won!"
		end

		if safe == false
			body_part = @body_parts.sample
			puts "That letter is not in the word. Sorry you lost your #{body_part}!"
			@body_parts.delete(body_part)
		end

		if @body_parts.empty?
			@game_over = true
			puts "You lost!"
		end
	end
	def end_game
		puts "The word was #{@random_word}"
		exit(0)
	end

	def save
		Dir.mkdir('games') unless Dir.exist? 'games'
		name = 'games/saved.yaml'
		File.open(name, 'w') do |file|
			file.puts YAML.dump(self)
		end
		puts "Game has been saved!"
	end

	def load
		content = File.open('games/saved.yaml', 'r') {|file| file.read }
		YAML.load(content)
	end
end

Hangman.new