class String
  def to_chars
    self.scan(/./)
  end
end

class String
def wordsendingwith(words, added)
	words_match = case 
		when added < 0 
			words.select {|word| word =~ /\A..*#{self}\Z/}
		when added == 1 
			words.select {|word| word =~ /\A.#{self}\Z/}
		when added == 2
			words.select {|word| word =~ /\A..#{self}\Z/}
		when added == 3
			words.select {|word| word =~ /\A...#{self}\Z/}
		when added == 4
			words.select {|word| word =~ /\A....#{self}\Z/}
		when added == 5
			words.select {|word| word =~ /\A.....#{self}\Z/}
		when added == 0 
			words.select {|word| word =~ /\A#{self}\Z/}
		end	
end
end

class String
def wordsbeginningwith(words, added)
	words_match = case 
		when added < 0 
			words.select {|word| word =~ /\A#{self}..*\Z/}
		when added == 1 
			words.select {|word| word =~ /\A#{self}.\Z/}		
		when added == 2 
			words.select {|word| word =~ /\A#{self}..\Z/}
		when added == 3 
			words.select {|word| word =~ /\A#{self}...\Z/}
		when added == 4 
			words.select {|word| word =~ /\A#{self}....\Z/}
		when added == 5 
			words.select {|word| word =~ /\A#{self}.....\Z/}
		when added == 0 
			words.select {|word| word =~ /\A#{self}\Z/}
		end
end
end

class String
def iswithinwords(words)
	words_match = words.select {|word| word =~ /\A..*#{self}..*\Z/}
end
end

class String
def iscontainedwords(words)
	words_match = words.select {|word| word =~ /\A.*#{self}.*\Z/}
end
end

class String
def isaword(words)
	words_match = words.select {|word| word =~ /\A#{self}\Z/}
	#puts "size #{words_match.size}"
	if words_match.size > 0
		return words_match
	else
		return nil
	end
end
end

class Array
	def powerset
		num = 2**size
		ps = Array.new(num, [])
		self.each_index do |i|
			a = 2**i
			b = 2**(i+1) - 1
			j = 0
			while j < num-1
				for j in j+a..j+b
				ps[j] += [self[i]]
				end
				j += 1
			end
		end
	ps
	end
end

class Array
  def >(other_set)
    (other_set - self).empty?
  end
end

class Array
	def subset?(other)
	    self.each do |x|
	     if !(other.include? x)
	      return false
	     end
	    end
	    true
	end
	def superset?(other)
	    other.subset?(self)
	end
end
