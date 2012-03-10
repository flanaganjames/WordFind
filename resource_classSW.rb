class ScrabbleWord
	attr_accessor :astring, :xcoordinate, :ycoordinate, :direction, :score, :supplement
	
	def initialize (astring, xcoordinate, ycoordinate, direction, score, supplement)
		@astring = astring
		@xcoordinate = xcoordinate
		@ycoordinate = ycoordinate
		@direction = direction
		@score = score
		@supplement = supplement
	end
	
	def print (source)
		puts "#{source}>  #{self.astring}, x=#{self.xcoordinate}, y=#{self.ycoordinate}, dirx: #{self.direction}, score: #{self.score}, suppl: #{self.supplement}, total: #{self.score + self.supplement}"
	end
	
	def wordfindcontains (allwords, tileset)
	possibles = []
	tiles = tileset.to_chars
	tiles_plus_anchor = tiles + self.astring.to_chars
	tilepower = tiles_plus_anchor.powerset
	anchorword_plus = self.astring.iscontainedwords(allwords)
	tilepower_words = []
	tilepower.each {|array| tilepower_words << array.sort.join('') }
	anchor_words = anchorword_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
	anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - (word =~ /#{Regexp.quote(self.astring)}/), self.direction, 0, 0)
			
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - (word =~ /#{Regexp.quote(self.astring)}/),  self.ycoordinate, self.direction, 0, 0)
			
		end
		possibles.push(possible)
		}
	return possibles
	end
		
	def wordfindinline (allwords, tileset)
	possibles = []
	
	tiles = tileset.to_chars
	tiles_plus_anchor = tiles + self.astring.to_chars
	tilepower = tiles_plus_anchor.powerset

	#the following finds words ending with the anchor word plus at least one character
	anchorword_plus = self.astring.wordsendingwith(allwords, -1)
	tilepower_words = []
	tilepower.each {|array| tilepower_words << array.sort.join('') }
	anchor_words = anchorword_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
	
	anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - (word.length - self.astring.length), self.direction, 0, 0)
			
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - (word.length - self.astring.length),  self.ycoordinate , self.direction, 0, 0)
			
		end
		possibles.push(possible)
		}
		
	#the following finds words beginning with the anchor word plus at least one character
	anchorword_plus = self.astring.wordsbeginningwith(allwords, -1)
	tilepower_words = []
	tilepower.each {|array| tilepower_words << array.sort.join('') }
	anchor_words = anchorword_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
	anchor_words.each { |word|
		possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate, self.direction, 0, 0)
		
		possibles.push(possible)
		}
		
	#the following finds words with the anchor word imbedded, ie plus at least one character on either end
	anchorword_plus = self.astring.iswithinwords(allwords)
	tilepower_words = []
	tilepower.each {|array| tilepower_words << array.sort.join('') }
	anchor_words = anchorword_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
	anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - (word =~ /#{Regexp.quote(self.astring)}/), self.direction, 0, 0)
			
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - (word =~ /#{Regexp.quote(self.astring)}/),  self.ycoordinate, self.direction, 0, 0)
			
		end
		possibles.push(possible)
		}
	
	return possibles
	end


	def wordfindorthostart(allwords, tiles)
	#Orthogonal to the start of self (paced at right angles to and before the start of self)
	anchors = []
	base_words = []
	possibles = []

	#Orthogonal to the beginning of self
	#find words that add a single character that is present in the tiles to the beginning of self; 
	words =  self.astring.wordsendingwith(allwords, 1)
	words.each {|word| possible_anchor = word[0]
		if tiles.include? possible_anchor
			base_words << word
			anchors << possible_anchor
		end
		}
	#base_words is the array of words that can be created by adding a single letter to the beginning of self; 
	#anchors is the array of single letters need to create those words
	
	
	#initially the following is an array of the tile characters, onto which we push a single anchor_letter at beginning of a cycle and then pop it off at the end
	tiles_plus_anchor = tiles.to_chars
		y = 0
	while y < anchors.length
		anchor_letter = anchors[y]  # for each anchor letter we find words beginning with, ending with and containing this letter
		tiles_plus_anchor << anchor_letter
		tilepower = tiles_plus_anchor.powerset
		tilepower_words = []
				
		anchor_words_plus = anchor_letter.wordsbeginningwith(allwords, -1)
		tilepower.each {|array| tilepower_words << array.sort.join('') }
		anchor_words = anchor_words_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
		anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate,  self.ycoordinate - 1, "down", 0, 0)
			
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - 1,  self.ycoordinate, "right", 0, 0)

		end
		possibles.push(possible)
		}
							
		anchor_words_plus = anchor_letter.wordsendingwith(allwords, -1)
		tilepower.each {|array| tilepower_words << array.sort.join('') }
		anchor_words = anchor_words_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
		anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate - word.length + 1,  self.ycoordinate - 1, "down", 0, 0)

		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - 1 ,  self.ycoordinate - word.length + 1, "right", 0, 0)

		end
		possibles.push(possible)
		}
				
		anchor_words_plus = anchor_letter.iswithinwords(allwords)
		tilepower.each {|array| tilepower_words << array.sort.join('') }
		anchor_words = anchor_words_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
		anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate - (word =~ /#{Regexp.quote(anchor_letter)}/) ,  self.ycoordinate - 1 , "down", 0, 0)
		
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate - 1 ,  self.ycoordinate + (word =~ /#{Regexp.quote(anchor_letter)}/), "right", 0, 0)

		end
		possibles.push(possible)
		}
		
		tiles_plus_anchor.pop
		y += 1
	end
	return possibles
	end

	def wordfindorthoend(allwords, tiles)
	#Orthogonal to the end of self (placed at right angles to and after the end of self)
	anchors = []
	base_words=[]
	possibles = []

	#Orthogonal to the beginning of self
	#find words that add a single character that is present in the tiles to the end of self;
	words =  self.astring.wordsbeginningwith(allwords, 1)
	words.each {|word| possible_anchor = word[word.length - 1]
		if tiles.include? possible_anchor
			base_words << word
			anchors << possible_anchor
		end
		}
	#base_words is the array of words that can be created by adding a single letter to the beginning of self; 
	#anchors is the array of single letters need to create those words
	
	
	#initially the following is an array of the tile characters, onto which we push a single anchor_letter at beginning of a cycle and then pop it off at the end
	tiles_plus_anchor = tiles.to_chars
		y = 0
	while y < anchors.length
		anchor_letter = anchors[y]  # for each anchor letter we find words beginning with, ending with and containing this letter
		tiles_plus_anchor << anchor_letter
		tilepower = tiles_plus_anchor.powerset
		tilepower_words = []
		#beginning with anchor letter
		anchor_words_plus = anchor_letter.wordsbeginningwith(allwords, -1)
		tilepower.each {|array| tilepower_words << array.sort.join('') }
		anchor_words = anchor_words_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
		anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate ,  self.ycoordinate + self.astring.length, "down", 0, 0)
	
		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate + self.astring.length ,  self.ycoordinate, "right", 0, 0)

		end
		possibles.push(possible)
		}
		#ending with anchor letter
		anchor_words_plus = anchor_letter.wordsendingwith(allwords, -1)
		tilepower.each {|array| tilepower_words << array.sort.join('') }
		anchor_words = anchor_words_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
		anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate - word.length + 1 ,  self.ycoordinate + self.astring.length , "down", 0, 0)

		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate + self.astring.length ,  self.ycoordinate - word.length + 1, "right", 0, 0)

		end
		possibles.push(possible)
		}
		#containing anchor letter
		anchor_words_plus = anchor_letter.iswithinwords(allwords)
		tilepower.each {|array| tilepower_words << array.sort.join('') }
		anchor_words = anchor_words_plus.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
		anchor_words.each { |word|
		
		case
		when self.direction == 'right'
			possible = ScrabbleWord.new(word, self.xcoordinate  - (word =~ /#{Regexp.quote(anchor_letter)}/) ,  self.ycoordinate + self.astring.length, "down", 0, 0)

		when self.direction == 'down'
			possible = ScrabbleWord.new(word, self.xcoordinate + self.astring.length ,  self.ycoordinate - (word =~ /#{Regexp.quote(anchor_letter)}/), "right", 0, 0)

		end
		possibles.push(possible)
		}
		
		tiles_plus_anchor.pop
		y += 1
	end
	return possibles
	end

	def wordfindorthomid(allwords, tiles)
		possibles = []
		letterSWs = []
		letters = self.astring.to_chars #take the basword and create an array of letters
		#make each letter into a ScrabbleWord with direction orthogonal to the baseword
		letters.each_index {|index| 
			case
			when self.direction == "right"
			aSW = ScrabbleWord.new(letters[index], self.xcoordinate, self.ycoordinate + index, "down", 0, 0)

			when self.direction == "down"
			aSW = ScrabbleWord.new(letters[index], self.xcoordinate + index, self.ycoordinate, "right", 0, 0)

			end
			letterSWs << aSW
		} 
		letterSWs.each {|letterSW| possibles += letterSW.wordfindinline(allwords, tiles)}
	return possibles
	end

	def scoreword (myboard)
		ascore = 0
		i = 0
		anarray = []
		anarray << 1
		while i < self.astring.length
			case
			when self.direction == "right"
				gridvalue = myboard.scoregrid[self.xcoordinate][self.ycoordinate + i]
				if myboard.lettergrid[self.xcoordinate][self.ycoordinate + i] == '-' 
					then occupied = "false"
					else occupied = "true"
					end
				#puts "gridvalue: #{gridvalue}; occupied: #{occupied}"
			when self.direction == "down"
				gridvalue = myboard.scoregrid[self.xcoordinate + i][self.ycoordinate]
				if myboard.lettergrid[self.xcoordinate + i][self.ycoordinate] == '-' 
					then occupied = "false"
					else occupied = "true"
					end
			end
			
			case			
			when gridvalue == "."
				ascore = ascore + myboard.lettervalues[self.astring[i]]
			when gridvalue == "l"
				if occupied =="false" 
					then
					ascore = ascore + 2 * myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "L"
				if occupied == "false" 
					then
					ascore = ascore + 3 * myboard.lettervalues[self.astring[i]]
					else
					ascore = ascore + myboard.lettervalues[self.astring[i]]
					end
			when gridvalue == "w"
				ascore = ascore + myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray << 2
					end
			when gridvalue == "W"
				ascore = ascore + myboard.lettervalues[self.astring[i]]
				if occupied == "false" 
					then
					anarray <<  3
					end
			end
			i += 1
		end
		wordscore = ascore * anarray.max
		self.score = wordscore
	end


end






