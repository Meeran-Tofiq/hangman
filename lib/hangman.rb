WORDS = File.readlines('google-10000-english-no-swears.txt', chomp: true)

class Game
    attr_reader :board, :player
    def initialize
        @word = self.pick_random_word
        @board = Board.new(@word)
        @player = Player.new(@board)
    end

    def play
        board.display_board
        return false
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
    attr_reader :board, :guesses, :word
    def initialize(word)
        @word = word
        @board = Array.new(word.length) {"_ "}
        @guesses = Array.new
    end

    def display_board
        board.each do |letter|
            print letter
        end
        puts "\n\n"
    end
end

class Player
    attr_reader :board
    def initialize(board)
        @board = board
    end

    def make_guess(guess)
        guess = guess.downcase

        if guesses.include?(guess) || !("a".."z").include?(guess)
            return false
        else
            if word.include?(guess)
                board[word.index(guess)] = guess.upcase + " "
            else
                puts "That is incorrect!"
            end
        end

        return true
    end
end    

replay = true

while replay
    game = Game.new
    replay = game.play
end