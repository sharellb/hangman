require 'yaml' #require the yaml libary to save and load games

class Hangman 
	
	def initialize
		@game_over = false #set the game_over variable to false
		@body_parts = ["right arm", "left arm", "right leg", "left leg", "head", "torso"] #set body parts
		@previous_guesses =[]
		select_word
	end

	def play #method to play the game
		until @game_over == true
			guess
		end
		puts "The word was #{@random_word}"
	end

	def select_word #open dictionary file and store all words between 5 and 12 characters in the words array
		words = []
		lines = File.readlines "5desk.txt"
		lines.each do |line|
			word = line.chomp
			if word.length > 5 && word.length < 12
				words.push(word)
			end
		end

		@random_word = words.sample.downcase #use sample method to store a random object from the words array
		@hidden_word = "-" * @random_word.length #display "-"" for every charachter of the random_word to display to user
		
	end

	def guess
		puts @hidden_word
		puts "Letters guessed: #{@previous_guesses}"
		puts "You have the following body parts: #{@body_parts}"
		puts "Guess a letter! or type 'save' to save the game."
		letter_guess = gets.chomp.downcase #get guess input from the user

		if letter_guess == 'save' 
			save
			exit(0) #exit out of loop
		elsif !letter_guess.match(/[[:alpha:]]/) #if input is not a letter
			puts "That is not a letter. Try again!"
			guess
		elsif letter_guess.length != 1 #if the input is not exactly 1 character
			puts "You must guess one letter. Try again!"
			guess
		elsif @previous_guesses.include?(letter_guess)
			puts "You already guessed that letter. Try again!"
		#if input is valid for each random_word if the guessed letter is equal to the actual letter replace it in the hidden word
		else 
			position = 0 
			lose_body_part = true 
			@random_word.split("").each do |letter|
				if letter_guess == letter
					@hidden_word[position] = letter 
					lose_body_part = false #do not execute lose_body_part
				end
				position += 1
			end
			@previous_guesses.push(letter_guess)
		end

		if @random_word == @hidden_word #end the game if the user has revealed the word
			@game_over = true
			puts "You won!"
		end

		if lose_body_part == true #remove random body part
			body_part = @body_parts.sample 
			puts "That letter is not in the word. Sorry you lost your #{body_part}!"
			@body_parts.delete(body_part) 
		end

		if @body_parts.empty? #end the game if there are no more body parts
			@game_over = true
			puts "You lost!"
		end
	end
end

def save #save the game as a yaml file into the games directory
	Dir.mkdir('games') unless Dir.exist? 'games'
	name = 'games/saved.yaml'
	File.open(name, 'w') do |file|
		file.puts YAML.dump(self)
	end
	puts "Game has been saved!"
end

def start_game 
	puts "Welcome to Hangman! Do you want to load an old game? (y/n)"
	old_game = gets.chomp
	if old_game == "y" #load old game
		content = File.open('games/saved.yaml', 'r') {|file| file.read }
		game = YAML.load(content) 
		game.play
	elsif old_game == "n" #start new game
		game = Hangman.new
		game.play
	else
		puts "That's not an option. Try again!"
		start_game
	end
end

start_game

