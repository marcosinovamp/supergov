class Player < ApplicationRecord
    has_many :stacks
    has_many :games, through: :stacks
end
