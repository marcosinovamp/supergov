class Game < ApplicationRecord
    has_many :hands
    has_many :stacks
    has_many :players, through: :stacks
end
