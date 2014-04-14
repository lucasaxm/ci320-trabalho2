# -*- coding: utf-8 -*-
require 'rubygems'
require 'active_record'
require 'sqlite3'

ActiveRecord::Base.establish_connection	:adapter => "sqlite3",
					:database => "PokemonRuby.sqlite3"

ActiveRecord::Base.connection.create_table :trainers do |t|  
	t.string	:name
	t.string	:city
	t.integer	:badges
end

ActiveRecord::Base.connection.create_table :pokemons do |t|
	t.string	:name
	t.integer	:pokedex_number
	t.string	:poketype
	t.integer	:n_moves
	t.integer	:trainer_id
end

ActiveRecord::Base.connection.create_table :moves_pokemons do |t|
	t.integer	:pokemon_id
	t.integer	:move_id
end

ActiveRecord::Base.connection.create_table :moves do |t|
	t.string	:name
	t.string	:movetype
	t.string	:category
end

ActiveRecord::Base.connection.create_table :bags do |t|
	t.integer	:pokeballs
	t.integer	:potions
	t.integer	:trainer_id
end

# one-to-one: 		trainer has one bag, bag belongs to trainer.
# one-to-many: 		pokemon belongs to trainer, trainer has many pokemons
# many-to-many: 	pokemon has many moves, move has many pokemons.


