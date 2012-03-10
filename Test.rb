require './resource_methodsOO'
require './resource_classSW'
require './resource_classBoard'

myboard = ScrabbleBoard.new
myboard.initialvalues
myboard.readboard("../Games/board.txt")
myboard.readscores("scores.txt")
words = File.readlines("wordlist.txt").map { |line| line.chomp }
word = ScrabbleWord.new("nuts", 0, 2, "down",0,0)
tiles="usoaaif"
myboard.findBoardSWs


#tilewords =myboard.findtilewords(words, tiles)
#coordinates = myboard.findblankparallelpositions
tilewords = []
tilewords << "quo"
coordinates = []
coordinates << [5,3,"right"]

found = myboard.placetilewords(tilewords, coordinates)
found = found.select {|possible| myboard.testwordsgenortho(possible, words)}
found.each {|aSW| aSW.print("")}
print " found #{found.size}"

