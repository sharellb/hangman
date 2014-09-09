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
		letter_guess = gets.chomp.downcase

		if !letter_guess.match(/[[:alpha:]]/)
			puts "That is not a letter. Try again!"
			guess
		elsif letter_guess.length != 1
			puts "You must guess one letter. Try again!"
			guess
		else
			position = 0
			@random_word.split("").each do |x|
				if letter_guess == x
					@hidden_word[position] = letter_guess
				end
				position = position + 1
			end
		end

		if @random_word == @hidden_word
			@game_over = true
		end
	end
	def end_game
		puts "The word was #{@random_word}"
		puts "You won!"
	end
end

Hangman.new