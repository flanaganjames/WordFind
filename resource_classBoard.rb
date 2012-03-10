class ScrabbleBoard
	attr_accessor :lettergrid, :scoregrid, :dimension, :lettervalues, :boardSWs
	
	def initialvalues #this method fills the letter grid array dimension x dimension with nil, the scoregrid with 1s except as defined
		self.dimension = 15
		self.lettergrid = []
		self.scoregrid = []
		self.lettervalues = {'a' => 1, 'b' => 4, 'c' => 4, 'd' => 2, 'e' => 1, 'f' => 4, 'g' => 3, 'h' => 3, 
		'i' => 1, 'j' => 1, 'k' => 1, 'l' => 2, 'm' => 4, 'n' => 2, 'o' => 1, 'p' => 4, 'q' => 10, 'r' => 1, 
		's' => 1, 't' => 1, 'u' => 2, 'v' => 5, 'w' => 4, 'x' => 8, 'y' => 3, 'z' => 1,}
		i = 0
		while i < self.dimension
			j = 0
			larray = []
			sarray = []
			while j < self.dimension
				larray << '-'
				sarray << 1
				j += 1
			end
			self.lettergrid << larray
			self.scoregrid << sarray
			i += 1
		end
	end
	
	def printboard
		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.lettergrid[i][j]
				j += 1
			end
			puts anarray.join(' | ')
			puts "_________________________________________________________"
			i += 1
		end		
		
	end
		
	def findtilewords (words, tileset) #from all words select those that can be made using existing tiles only (all other word options are found by anchoring to existing boardSWs)
	tilewords = []
	tiles = tileset.to_chars
	tiles_plus_anchor = tiles
	tilepower = tiles.powerset
	tilepower_words = []
	tilepower.each {|array| tilepower_words << array.sort.join('') }
	anchor_words = words.select {|word| tilepower_words.include?(word.scan(/./).sort.join(''))}
	anchor_words.each { |word|
		tilewords.push(word)
		}
	return tilewords
	end

	def findblankparallelpositions #find all blank positions where a tileword could be placed - in any register -; note a coordinate is a triple: x, y,, direction
		coordinates = []
		currentSWs = self.boardSWs
		currentSWs.each { |aSW|
			case
			when aSW.direction == "right"
					i = 0
					while i < aSW.astring.size
						x = aSW.xcoordinate - 1
						y = aSW.ycoordinate + i
						if (x > -1)  #if a valid coordinate
						then	
							if self.lettergrid[x][y] == '-'
								then coordinates << [x, y, "right"]
							end
						end		
						x = aSW.xcoordinate + 1
						y = aSW.ycoordinate + i
						if (x < (self.dimension)) #if a valid coordinate
						then	
							if self.lettergrid[x][y] == '-'
								then coordinates << [x, y, "right"]
							end
						end
					i += 1
					end
			when aSW.direction == "down"
					i = 0
					while i < aSW.astring.size
						x = aSW.xcoordinate + i
						y = aSW.ycoordinate - 1
						
						if (y > -1) #if a valid coordinate
						then
							if self.lettergrid[x][y] == '-'
							then coordinates << [x, y, "down"]
							end
						end		
						x = aSW.xcoordinate + i
						y = aSW.ycoordinate + 1
						if (y < (self.dimension)) #if a valid coordinate
						then
							if self.lettergrid[x][y] == '-'
							then coordinates << [x, y, "down"]
							end
						end
					i += 1
					end
			end
			}
		return coordinates
	end
	
	def placetilewords (tilewords, coordinates) #return possibleSWs formed by placing each tileword in every blankposition in every register as long as the SW does not cover a non-empty gird location with a different letter
		possibles = []
		tilewords.each {|word|
			coordinates.each {|coord|
				i = 0
				while i < word.size #the position of the first letter can be one of size positions relative to the coordinate
					wordposition = 0
					status = "true"
					while (wordposition < word.size) && status == "true" # then for each word position check if each of its letters is an an available gird position
						case
							when coord[2] == "right"
								x = coord[0]
								y = coord[1] - i + wordposition							
							when coord[2] == "down"
								x = coord[0] - i + wordposition
								y = coord[1]
						end
						if (0 < x) && (x < self.dimension) && (0 < y) && (y < self.dimension) #if x or y calls invalid dimension then cannot place word
						then 
							if lettergrid[x][y] == '-'
								then status = "true"
							elsif lettergrid[x][y] == word[wordposition]
								then status = "true"
							else
								status = "false"
							end
						else
							status = "false"
						end
					wordposition += 1
					end #status true after checking weach wordposition or false because one of the positions could not be placed 
					if status == "true" #
						then 
							case
								when coord[2] == "right"
									possibles << ScrabbleWord.new(word, coord[0], coord[1] - i, "right", 0, 0)
								when coord[2] == "down"
									possibles << ScrabbleWord.new(word, coord[0] - i, coord[1],  "down", 0, 0)
							 end
					end
				i+= 1
				end
			}
		}	
	return possibles
	end
	
	def loadword (word) #this method takes any scrabble word and places its letter content onto the letter grid
		case
		when word.direction == "right"
			i = 0
			while i < word.astring.length
				self.lettergrid[word.xcoordinate][word.ycoordinate + i] = word.astring[i]
				i += 1
			end
		when word.direction == "down"
			i = 0
			while i < word.astring.length
				self.lettergrid[word.xcoordinate + i][word.ycoordinate] = word.astring[i]
				i += 1
			end	
		end
	end 
	
	def testwordonboard (word)
	status = "true"
		case
		when word.direction == "right"
			if word.ycoordinate + word.astring.length > self.dimension
				then status = nil
			elsif not((word.ycoordinate > -1) && (word.ycoordinate < self.dimension))
				then status = nil
			elsif not((word.xcoordinate > -1) && (word.xcoordinate < self.dimension))
				then status = nil 
			end
		when word.direction == "down" 
			if word.xcoordinate + word.astring.length > self.dimension
				then status = nil
			elsif not((word.ycoordinate > -1) && (word.ycoordinate < self.dimension))
				then status = nil 
			elsif not((word.xcoordinate > -1) && (word.xcoordinate < self.dimension))
				then status = nil 
			end
		end
	return status
	end
	
	
	
	def testwordoverlap (word) #this method tests a possible word addition, rejects if goes beyond dimension or requires a letter grid position to change from one letter to another
			status = "true"
			case
			when word.direction == "right"
				i = 0
				count = 0
				while i < word.astring.length && status == "true"
					if	(self.lettergrid[word.xcoordinate][word.ycoordinate + i] == "-")
					then 
						status = "true"
						count += 1
					elsif  (self.lettergrid[word.xcoordinate][word.ycoordinate + i] == word.astring[i])
					then 
						status = "true"
					else
						status = nil
					end
					i += 1
				end
				if count == 0 
				then status = nil 
				end #at least one '-' space must be covered to be valid
			when word.direction == "down" 
				i = 0
				count = 0
				while i < word.astring.length && status == "true"
					if	(self.lettergrid[word.xcoordinate + i][word.ycoordinate] == "-")
					then 
						status = "true"
						count += 1
					elsif  (self.lettergrid[word.xcoordinate + i][word.ycoordinate] == word.astring[i])
					then 
						status = "true"
					else
						status = nil
					end
					i += 1
				end
				if count == 0 
				then status = nil 
				end #at least one '-' space must be covered to be valid
			end
		return status
	end

	def testwordsgeninline (word, words) #this method tests a possible word addition, rejects if it creates a non-word in line with the test word
		#not done yet: it should also supplement the score if it generates another word inline or at right anlels
		#not done yet:the final score of the word tested will be added to this supplement score
			#puts word.print("starting word")
			case
			when word.direction == "right"
				testwordarray = []
				#find left
				testposition = word.ycoordinate - 1
				leftposition = "not found"
				while testposition > -1 && leftposition == "not found"
					if self.lettergrid[word.xcoordinate][testposition] == "-"
						then leftposition = testposition + 1
						end
					testposition -= 1
				end
				if leftposition == "not found" 
					then leftposition = 0
					end
				#puts "leftposition #{leftposition}"
				#find right
				testposition = word.ycoordinate + word.astring.size
				rightposition = "not found"
				while testposition < self.dimension && rightposition == "not found"
					if self.lettergrid[word.xcoordinate][testposition] == "-"
						then rightposition = testposition - 1
						end
					testposition += 1
				end
				if rightposition == "not found" 
					then rightposition = self.dimension - 1
					end
				#puts "rightposition #{rightposition}"
				#fill in left part of array
				currentposition = leftposition
				while currentposition < word.ycoordinate
					testwordarray << self.lettergrid[word.xcoordinate][currentposition]
					currentposition += 1
				end
	
				#fill the word into the array; at this point currentposition = word.ycoordinate
				wordfactorarray = []
				wordfactorarray << 1
				while  currentposition < word.ycoordinate + word.astring.length 
					testwordarray << word.astring[currentposition - word.ycoordinate]
					case
						when (self.scoregrid[word.xcoordinate][currentposition] == 'w' && self.lettergrid[word.xcoordinate][currentposition] == '-')
							wordfactorarray << 2
						when (self.scoregrid[word.xcoordinate][currentposition]  == 'W' && self.lettergrid[word.xcoordinate][currentposition] == '-')
							wordfactorarray << 3
					end
					currentposition += 1
				end
				wordfactor = wordfactorarray.max
				
				#fill in right part of array
				while currentposition < rightposition + 1
					testwordarray << self.lettergrid[word.xcoordinate][currentposition]
					currentposition += 1
				end
				#puts "wordgenerated #{testwordarray.join('')}"
				status = testwordarray.join('').isaword(words)
				#puts "status #{status} for word #{testwordarray.join('')} from inline right"
				if status
					then
					#score for full word generated inline - score for the proposed word is the supplement
					generatedword = ScrabbleWord.new(testwordarray.join(''),word.xcoordinate,leftposition,"right",0,0)
					#puts generatedword.print("temp inline right generated")
					#puts word.print("temp inline right source")
					difference = generatedword.scoreword(self) - word.scoreword(self)
					word.supplement = word.supplement + difference
					
				end

			when word.direction == "down" 
				testwordarray = []
				#find left
				testposition = word.xcoordinate - 1
				leftposition = "not found"
				while testposition > -1 && leftposition == "not found"
					if self.lettergrid[testposition][word.ycoordinate] == "-"
						then leftposition = testposition + 1
						end
					testposition -= 1
				end
				if leftposition == "not found" 
					then leftposition = 0
					end
				#puts "leftposition #{leftposition}"
				#find right
				testposition = word.xcoordinate + word.astring.size
				rightposition = "not found"
				while testposition < self.dimension && rightposition == "not found"
					if self.lettergrid[testposition][word.ycoordinate] == "-"
						then rightposition = testposition - 1
						end
					testposition += 1
				end
				if rightposition == "not found" 
					then rightposition = self.dimension - 1
					end
				#puts "rightposition #{rightposition}"
				#fill in left part of array
				currentposition = leftposition
				while currentposition < word.xcoordinate
					testwordarray << self.lettergrid[currentposition][word.ycoordinate]
					currentposition += 1
				end
	
				#fill the word into the array
				while  currentposition < word.xcoordinate + word.astring.length 
					testwordarray << word.astring[currentposition - word.xcoordinate]
					currentposition += 1
				end
				
				
				#fill in right part of array
				while currentposition < rightposition + 1
					testwordarray << self.lettergrid[currentposition][word.ycoordinate]
					currentposition += 1
				end
				
				status = testwordarray.join('').isaword(words)
				#puts "status #{status} for word #{testwordarray.join('')} from inline down"
				if status
					then
					#score for full word generated inline - score for the proposed word is the supplement
					generatedword = ScrabbleWord.new(testwordarray.join(''),leftposition,word.ycoordinate,"down",0,0)
					#puts generatedword.print("temp inline down generated")
					#puts word.print("temp inline down source")
					difference = generatedword.scoreword(self) - word.scoreword(self)
					word.supplement = word.supplement + difference
				end
				
				
			end

		return status
	end

	def testwordsgenortho (word, words) #this method tests a possible word addition, rejects if it creates a non-word orthogonal to the test word
		#not done yet: it should also supplement the score if it generates another word inline or at right anlels
		#not done yet:the final score of the word tested will be added to this supplement score
			#puts word.print("starting word")
			case
			when word.direction == "down"
			
				wordposition = 0
				status = []
				while (wordposition < word.astring.size && status != nil)
					if self.lettergrid[word.xcoordinate + wordposition][word.ycoordinate] == '-'
						testwordarray = []
						#find left
						testposition = word.ycoordinate - 1
						leftposition = "not found"
						while testposition > -1 && leftposition == "not found"
							if self.lettergrid[word.xcoordinate + wordposition][testposition] == "-"
								then leftposition = testposition + 1
								end
							testposition -= 1
						end
						if leftposition == "not found" 
							then leftposition = 0
							end
						#puts "leftposition #{leftposition}"
						#find right
						testposition = word.ycoordinate + 1
						rightposition = "not found"
						while testposition < self.dimension && rightposition == "not found"
							if self.lettergrid[word.xcoordinate + wordposition][testposition] == "-"
								then rightposition = testposition - 1
								end
							testposition += 1
						end
						if rightposition == "not found" 
							then rightposition = self.dimension - 1
							end
						#puts "rightposition #{rightposition}"
						if leftposition != rightposition 
						then
							#fill in left part of array
							currentposition = leftposition
							while currentposition < word.ycoordinate
								testwordarray << self.lettergrid[word.xcoordinate + wordposition][currentposition]
								currentposition += 1
							end
				
							#fill the word into the array; at this point currentposition = word.ycoordinate
							testwordarray << word.astring[wordposition]
							currentposition += 1
							
							
							#fill in right part of array
							while currentposition < rightposition + 1
								testwordarray << self.lettergrid[word.xcoordinate + wordposition][currentposition]
								currentposition += 1
							end
							status = testwordarray.join('').isaword(words)
							#puts "status #{status} for word #{testwordarray.join('')} from ortho down"
							if status
							then
								generatedword = ScrabbleWord.new(testwordarray.join(''),word.xcoordinate + wordposition,leftposition,"right",0,0)
								#puts generatedword.print("temp inline down generated")
								#puts word.print("temp inline down source")
								word.supplement = word.supplement + generatedword.scoreword(self)
								#puts "supplement: #{word.supplement}"
							end

						else
							status = []
						end
					end
				wordposition += 1
				end
			when word.direction == "right" 
			#puts "testwordsgenortho right"
				wordposition = 0
				status = []
				while (wordposition < word.astring.size  && status != nil)
					if self.lettergrid[word.xcoordinate][word.ycoordinate + wordposition] == '-'
						testwordarray = []
						#find left
						testposition = word.xcoordinate - 1
						leftposition = "not found"
						while testposition > -1 && leftposition == "not found"
							if self.lettergrid[testposition][word.ycoordinate + wordposition] == "-"
								then leftposition = testposition + 1
								end
							testposition -= 1
						end
						if leftposition == "not found" 
							then leftposition = 0
							end
						#puts "leftposition #{leftposition}"
						#find right
						testposition = word.xcoordinate + 1
						rightposition = "not found"
						while testposition < self.dimension && rightposition == "not found"
							if self.lettergrid[testposition][word.ycoordinate + wordposition] == "-"
								then rightposition = testposition - 1
								end
							testposition += 1
						end
						if rightposition == "not found" 
							then rightposition = self.dimension - 1
							end
						#puts "rightposition #{rightposition}"
						if leftposition != rightposition 
						then				
							#fill in left part of array
							currentposition = leftposition
							while currentposition < word.xcoordinate
								testwordarray << self.lettergrid[currentposition][word.ycoordinate + wordposition]
								currentposition += 1
							end
				
							#fill the word into the array; at this point currentposition = word.xcoordinate
							testwordarray << word.astring[wordposition]
							currentposition += 1
							
							
							#fill in right part of array
							while currentposition < rightposition + 1
								testwordarray << self.lettergrid[currentposition][word.ycoordinate + wordposition]
								currentposition += 1
							end
							
							status = testwordarray.join('').isaword(words)
							#puts "status #{status} for word #{testwordarray.join('')} from ortho right"
							if status
								then
								generatedword = ScrabbleWord.new(testwordarray.join(''),leftposition,word.ycoordinate + wordposition,"down",0,0)
								#puts generatedword.print("temp inline down generated")
								#puts word.print("temp inline down source")
								word.supplement = word.supplement +  generatedword.scoreword(self)
								#puts "supplement: #{word.supplement}"
							end						
						else
							status = []
						end
					end
				wordposition += 1
				end
			end
		return status
	end

	def readboard (afilename)
		rows = File.readlines(afilename).map { |line| line.chomp } #this is an array of the board rows each as a string
			rows.each_index {|i| 
			rowletters = rows[i].to_chars # this is an array of characters for one of the rows
			rowletters.each_index {|j|
			self.lettergrid[i][j] = rowletters[j]
			}
		}
		
	end
	
	def writeboard (afilename)
		afile = File.open(afilename, "w")
		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.lettergrid[i][j]			
			j += 1
			end
			afile.puts(anarray.join())
		i += 1
		end
		afile.close
	end

	def readscores (afilename)
		rows = File.readlines(afilename).map { |line| line.chomp } #this is an array of the board rows each as a string
			rows.each_index {|i| 
			rowletters = rows[i].to_chars # this is an array of characters for one of the rows
			rowletters.each_index {|j|
			self.scoregrid[i][j] = rowletters[j]
			}
		}
		
	end
	
	def printscores
		i = 0
		while i < self.dimension
			j = 0
			anarray = []
			while j < self.dimension
				anarray << self.scoregrid[i][j]
				j += 1
			end
			puts anarray.join(' | ')
			puts "_________________________________________________________"
			i += 1
		end		
		
	end	
	
	def findBoardSWs
		self.boardSWs = []
		#find words going down
		
		j = 0 
		while j < self.dimension # for the jth column
			i = 0
			
			while i < (self.dimension - 1) #look for the start of a SW
				if self.lettergrid[i][j] != "-"
				then	if self.lettergrid[i+1][j] != "-" #start a word
						
						anarray = []
						anarray << self.lettergrid[i][j]
						anarray << self.lettergrid[i+1][j]
						# find the coordinate of the end
						h = i + 2
						while h < self.dimension && self.lettergrid[h][j] != "-"
							anarray << self.lettergrid[h][j]
							h += 1
						end
						aword = ScrabbleWord.new(anarray.join, i, j, "down", 0, 0)

						self.boardSWs << aword
						i = h + 1
					else 
						i += 2
					end
				else 
					i += 1
				end
			end
			j += 1
		
		end
		
		#find words going right
		i = 0 
		while i < self.dimension # for the ith row
			j = 0
			
			while j < (self.dimension - 1) #look for the start of a SW
				if self.lettergrid[i][j] != "-"
				then	if self.lettergrid[i][j+1] != "-" #start a word
						
						anarray = []
						anarray << self.lettergrid[i][j]
						anarray << self.lettergrid[i][j+1]
						# find the coordinate of the end
						h = j + 2
						while h < self.dimension && self.lettergrid[i][h] != "-"
							anarray << self.lettergrid[i][h]
							h += 1
						end
						aword = ScrabbleWord.new(anarray.join, i, j, "right", 0, 0)

						self.boardSWs << aword
						j	 = h + 1
					else j += 2
					end
				else 
					j += 1
				end
			end
			i += 1
		
		end
	end
	
	
	def scorestring (astring)
		ascore = 0
		i = 0
		while i < astring.length
			ascore = ascore + self.lettervalues[astring[i]]
			i += 1
		end
		return ascore
	end

	def proposedchars(proposedSWs) #returns two dimensional array x, y of vectors containing proposed characters
		anarray = []
		x = 0
		while x < self.dimension
			y = 0
			yarray = []
			while y < self.dimension
				yarray << []
				y += 1
			end
			anarray << yarray
			x += 1
		end
		
		proposedSWs.each{|aSW|
			case
			when aSW.direction == "down"
				i = 0
				while i < aSW.astring.size
					anarray[aSW.xcoordinate + i][aSW.ycoordinate] << aSW.astring[i]
					i += 1
				end
			when aSW.direction == "right"
				i = 0
				while i < aSW.astring.size
					anarray[aSW.xcoordinate][aSW.ycoordinate + i] << aSW.astring[i]
					i += 1
				end
			end
		}

		return anarray
	end

end






