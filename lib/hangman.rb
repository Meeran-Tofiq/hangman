WORDS = File.readlines('google-10000-english-no-swears.txt', chomp: true)

class Game
    def initialize
        @word = self.pick_random_word
    end

    def pick_random_word
        word = WORDS.sample
        
        while word.length < 5 || word.length > 12
            word = WORDS.sample
        end
        
        word
    end
end

game = Game.new