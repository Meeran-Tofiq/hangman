WORDS = File.readlines('google-10000-english-no-swears.txt', chomp: true)
GAME_RULES = "This is a game of Hangman!

The computer selects a random word that has anywhere between 5 and 12 letters,
and the player has to guess the word by guessing the letters in it.

The player has 7 tries after which you'd lose. You can play another game after
that, or leave it.

This game also has the ability of saving, at the beginning you'll be queried f-
or a file if you want to load that file. Otherwise, you can just play normally."

class Game
    attr_reader :board, :player
    def initialize
        @word = self.pick_random_word
        @board = Board.new(@word)
        @player = Player.new(@board)
    end

    def play
        board.display_board
        win = false
        puts GAME_RULES

        until win
            break
        end

        prompt_replay
    end

    def pick_random_word
        word = WORDS.sample
        
        while word.length < 5 || word.length > 12
            word = WORDS.sample
        end
        
        word
    end

    def prompt_replay
        puts "Do you want to play again? (y/...)"
        replay = gets.chomp.downcase

        return (replay == 'y' ? true : false)
    end
end

class Board
    attr_reader :board, :guesses, :word
    def initialize(word)
        @word = word
        @board = Array.new(word.length) {"_"}
        @guesses = Array.new(7) {"O"}
    end

    def display_board
        board.each {|letter| print letter + " "}
        puts "\n"
        guesses.each {|guess| print guess + " " }
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
                board.board[word.index(guess)] = guess.upcase
            else
                puts "That is incorrect!"
                board.guesses[board.guesses.index("O")] = "X"
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