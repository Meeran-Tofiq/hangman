require 'pry-byebug'
require 'json'

WORDS = File.readlines('google-10000-english-no-swears.txt', chomp: true)
GAME_RULES = "This is a game of Hangman!

The computer selects a random word that has anywhere between 5 and 12 letters,
and the player has to guess the word by guessing the letters in it.

The player has 7 tries after which you'd lose. You can play another game after
that, or leave it.

This game also has the ability of saving, at the beginning you'll be queried f-
or a file if you want to load that file. Otherwise, you can just play normally.\n\n"

module Serializable
    @@Serializer = JSON

    def serialize
        obj = {}
        instance_variables.map do |var|
            obj[var] = instance_variable_get(var)
        end

        @@Serializer.dump obj
    end

    def unserialize(string)
        obj = @@Serializer.parse string
        obj.keys.each do |key|
            instance_variable_set(key, obj[key])
        end
    end
end

class Game
    attr_reader :board, :player, :save, :saves
    def initialize
        @word = self.pick_random_word
        @board = Board.new(@word)
        @player = Player.new(@board)
        @save = false
    end

    def play
        win = false
        lose = false
        puts GAME_RULES

        if load?
            @board.unserialize(load_save)
        end
        
        until win || lose
            board.display_board
            guess = prompt_guess
            player.make_guess(guess)

            if save
                save_game
                return
            end
            
            win = board.check_for_win

            if board.guesses.length == 7
                puts "\nYou lost!\n\n"
                lose = true
            end
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

    def prompt_guess
        puts "Guess a letter that can be part of the word, and that you haven't guessed yet.
        If you write SAVE, you will save the game and exit out of it."

        guess = gets.chomp.downcase

        until ("a".."z").include?(guess) || guess == "save"
            puts "Your guess must be a letter"
            guess = gets.chomp.downcase
        end

        @save = (guess == 'save')

        guess
    end

    def save_game
        unless Dir.exists? "saves"
            Dir.mkdir "saves"
        end

        @saves = File.open("saves/".concat(Time.now.strftime("%d_%m_%Y %H_%M")), "w+")

        saves.puts board.serialize
    end

    def load?
        puts "Do you want to load a previous save file? (load/...)"
        gets.chomp.downcase == "load"
    end

    def load_save
        saves_folder = Dir.open("saves").children
        puts "Which file do you want to load? "
        p saves_folder
        puts "Choose by writing the number of the file you want (#{saves_folder.length} - files available)"
        
        unless (answer = gets.chomp.to_i - 1) < saves_folder.length
            puts "You are exceeding the bounds of the folder"
        end

        File.read("./saves/" + saves_folder[answer]) 
    end

end

class Board
    include Serializable

    attr_reader :board, :guesses, :word
    def initialize(word)
        @word = word.split('')
        @board = Array.new(word.length) {"_"}
        @guesses = Array.new
    end

    def display_board
        board.each {|letter| print letter + " "}
        puts "\n"
        guesses.each {print "X"}
        puts "\n\n"
    end

    def check_for_win
        unless board.include?("_")
            puts "\n YOU WON! \n\n"
            return true
        end

        return false
    end
end

class Player
    attr_reader :board
    def initialize(board)
        @board = board
    end

    def make_guess(guess)
        guess = guess.downcase

        if guess == "save"
            return
        end

        if board.guesses.include?(guess)
            puts "You've already guessed that letter!"
            return false
        else
            if board.word.include?(guess)
                indexes = board.word.each_index.select{|i| board.word[i] == guess}
                indexes.each {|index| board.board[index] = guess}
            else
                puts "That is incorrect!"
                board.guesses << guess
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