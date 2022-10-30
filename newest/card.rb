class Card < ApplicationRecord
    belongs_to :deck

    def throw
        @stack = [Card.all.sample(10)]
    end
end
