
lines = File.readlines "5desk.txt"
lines.each do |line|
	word = line.chomp
	if word.length > 5 && word.length < 12
		puts word
	end
end