WORDS = File.readlines('google-10000-english-no-swears.txt', chomp: true)

class Game
    def initialize
        @word = self.pick_random_word
        @board = Board.new(@word)
    end

    def play
        @board.display_board
        return true
    end

    def pick_random_word
        word = WORDS.sample
        
        while word.length < 5 || word.length > 12
            word = WORDS.sample
        end
        
        word
    end
end

class Board
    def initialize(word)
        @board = Array.new(word.length) {"_ "}
        @guesses = Array.new
    end

    def display_board
        @board.each do |letter|
            print letter
        end
        puts "\n\n"
    end
end

game = Game.new
game.play