class Hangman
	attr_reader :game_over
	
	def initialize
		@game_over = false
		select_word
		welcome
		until game_over == true
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
		puts "Guess a letter!"
		letter_guess = gets.chomp

		position = 0
		@random_word.split("").each do |x|
			if letter_guess == x
				@hidden_word[position] = letter_guess
			end
			position = position + 1
		end

		if @random_word == @hidden_word
			@game_over = true
			puts "YAY"
		end
	end
	def end_game
		puts "You won"
	end
end

Hangman.new