
require './resource_methodsOO'
require './resource_classSW'
require './resource_classBoard'

myboard = ScrabbleBoard.new
myboard.initialvalues
myboard.readboard("Games/board.txt")
myboard.readscores("SWscoreResource.txt")
myboard.findBoardSWs
#myboard.printscores
#puts "Loaded Board"
#myboard.printboard


words = File.readlines("wordlist.txt").map { |line| line.chomp }
tiles = ARGV[0]


allpossibles = []
arraySWs = myboard.boardSWs
while arraySWs.size > 0
aSW = arraySWs.pop
aSWpossibles = []
aSW.wordfindorthostart(words, tiles).each {|aSW| aSWpossibles << aSW }
aSW.wordfindorthoend(words, tiles).each {|aSW| aSWpossibles << aSW }
aSW.wordfindorthomid(words, tiles).each {|aSW| aSWpossibles << aSW }
aSW.wordfindinline(words, tiles).each {|aSW| aSWpossibles << aSW }
aSWonboard = aSWpossibles.select {|aSW| myboard.testwordonboard(aSW)}
aSWquarterfinals = aSWonboard.select {|possible| myboard.testwordoverlap(possible)}
aSWsemifinals = aSWquarterfinals.select {|possible| myboard.testwordsgenortho(possible, words)}
aSWfinals = aSWsemifinals.select {|possible|myboard.testwordsgeninline(possible, words)}
aSWfinals.each {|aSW| allpossibles << aSW}
end

tilewords =myboard.findtilewords(words, tiles)
coordinates = myboard.findblankparallelpositions
possibles = myboard.placetilewords(tilewords, coordinates)
possibles.each {|aSW| aSW.print("")}
possibles = possibles.select {|possible|myboard.testwordsgeninline(possible, words)}
possibles = possibles.select {|possible| myboard.testwordsgenortho(possible, words)}
possibles.each {|aSW| allpossibles << aSW}

allpossibles.each {|possible| possible.scoreword(myboard)}
#allpossibles = allpossibles.sort_by {|possible| [-possible.score]}
allpossibles = allpossibles.sort_by {|possible| [-(possible.score + possible.supplement)]}
allpossibles.each {|possible| possible.print("Final>")}

afile = File.open("Games/possibles.txt", "w")
afile.puts "string, size, x, y, direction, score, supplement, total"
allpossibles.each {|aSW| afile.puts("#{aSW.astring},#{aSW.astring.size},#{aSW.xcoordinate},#{aSW.ycoordinate},#{aSW.direction},#{aSW.score},#{aSW.supplement},#{aSW.score + aSW.supplement}") }
afile.close




#create a class of BoardWords which have astring alocation ascore atype
#atype can be placed begin-with-placed end-with-placed ortho-bein-paced ortho-end-paced
#need to know the atype in order to calculate position from position of a atype=placed baseword


#have wordfile array created here and passed as an array so its not constantly being read into an array each time