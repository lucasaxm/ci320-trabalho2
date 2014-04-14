# -*- coding: utf-8 -*-
require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "PokemonRuby.sqlite3"

class Trainer < ActiveRecord::Base;
	has_many	:pokemons
	has_one		:bag

	def inserir
		puts 'Digite o nome do Treinador:'
		self.name = gets.chomp
		puts 'Digite a cidade de origem do Treinador:'
		self.city = gets.chomp
		puts 'Quantas insígnias '+self.name+' possui?'
		self.badges = gets.chomp.to_i
		puts 'Quantos pokemons '+self.name+' possui?'
		n_pokemons = gets.chomp.to_i
		self.save
		puts 'Deseja inserir os pokemons de '+self.name+' agora? (s/n)'
		if gets.chomp.downcase == 's'
			pokemon = Pokemon.new()
			n_pokemons.times do 
		 		pokemon = self.pokemons.build
		 		pokemon.inserir
		 	end
		end
		puts 'Deseja inserir Pokebolas e Poções na mochila de '+self.name+'? (s/n)'
		if gets.chomp.downcase=='s'
			self.save
			bag = self.build_bag
			bag.inserir
		end
		self.save
		puts 'Treinador '+self.name+' da cidade de '+self.city+' inserido com sucesso!'
		gets	#EsperaEnter
	end

	def remover
		puts 'Digite a ID do treinador: '
		puts '(Se você não sabe a ID do treinador, digite \'cancelar\' e use a opção de exibição.)'
		id = gets.chomp
		if id != 'cancelar'
			id = id.to_i
			treinador = Trainer.where(:id => id)
			if treinador.length>0
				puts 'Você tem certeza que deseja excluir o treinador '+treinador.first.name+'? (s/n)'
				if (gets.chomp.downcase == 's')
					nome = treinador.first.name
					treinador.first.pokemons.clear
					treinador.first.destroy
					puts 'O Treinador '+nome+' foi removido com sucesso.'
					gets #EsperaEnter
				end
			else
				puts 'A ID digitada não existe.'
				gets #EsperaEnter
			end
		end
	end

	def listartodos
		treinadores = Trainer.all;
		if treinadores.length==0
			puts 'Nenhum treinador registrado.'
		end
		treinadores.each do |t|
			t.me_imprima
		end
		gets	#EsperaEnter
	end

	def me_imprima
		puts ("ID: "+self.id.to_s)
		puts ("Nome: "+self.name)
		puts ("Cidade: "+self.city)
		puts ("Insígnias: "+self.badges.to_s)
		printf ("Pokemons: ")
		pokemons = self.pokemons
		if pokemons.length>0
			printf ("\n")
			pokemons.each do |p|
				printf ("\t")
				puts p.name
			end
		else
			puts 'Nenhum Pokemon'
		end
		mochila = Bag.where(:trainer_id => self.id)
		puts ("Conteúdo da Mochila:")
		if mochila.length>0
			printf "\t"
			puts mochila[0].pokeballs.to_s+" Pokebolas"
			printf "\t"
			puts mochila[0].potions.to_s+" Poções"
		else
			printf "\tTreinador não possui mochila.\n"
		end
		puts ("--------------------")
	end

	def exibe_pokemons
			puts "Trainer ID: "+self.id.to_s
			pokemons = self.pokemons
			pokemons.each do |p|
				p.me_imprima
			end
	end

	def pesquisar(op)
		encontrou = false
		case op
		when 2
			while !encontrou
				puts 'Digite o nome do Treinador:'
				nome = gets.chomp
				treinadores = Trainer.where(:name => nome)
				if treinadores.length>0
					treinadores.each do |t|
						t.me_imprima
					end
				else
					puts 'O treinador '+nome+' não existe!'
				end
				puts 'Deseja pesquisar novamente? (s/n)'
				if gets.chomp=='n'
					encontrou = true
				end
			end
		when 3
			while !encontrou
				puts 'Digite a cidade do Treinador:'
				cidade = gets.chomp
				treinadores = Trainer.where(:city => cidade)
				if treinadores.length>0
					treinadores.each do |t|
						t.me_imprima
					end
				else
					puts 'Não existe nenhum treinador que resida na cidade '+cidade+'.'
				end
				puts 'Deseja pesquisar novamente? (s/n)'
				if gets.chomp=='n'
					encontrou = true
				end
			end
		else
			puts 'Opção Inválida!'
		end
	end

	def atualizar(op)
		alterou = false
		case op
		when 1
			while !alterou
				puts 'Digite a ID do Treinador:'
				id = gets.chomp.to_i
				treinador = Trainer.where(:id => id).first
				if !treinador.nil?
					puts "Você escolheu o treinador "+treinador.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite o novo nome que deseja atribuir ao treinador '+treinador.name+':'
						novonome = gets.chomp
						puts "Confirma a mudança de '"+treinador.name+"' para '"+novonome+"'?(s/n)"
						if gets.chomp=='s'
							treinador.update_attribute :name, novonome
							puts "Nome alterado com sucesso!"
							alterou = true
							gets #EsperaEnter
						else
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe treinador com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 2

			while !alterou
				puts 'Digite a ID do Treinador:'
				id = gets.chomp.to_i
				treinador = Trainer.where(:id => id).first
				if !treinador.nil?
					puts "Você escolheu o treinador "+treinador.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite a nova cidade que deseja atribuir ao treinador '+treinador.name+' (cidade atual: '+treinador.city+'):'
						novacidade = gets.chomp
						puts "Confirma a mudança de '"+treinador.city+"' para '"+novacidade+"'?(s/n)"
						if gets.chomp=='s'
							treinador.update_attribute :city, novacidade
							puts "Cidade alterada com sucesso!"
							alterou = true
							gets #EsperaEnter
						else
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe treinador com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 3
			while !alterou
				puts 'Digite a ID do Treinador:'
				id = gets.chomp.to_i
				treinador = Trainer.where(:id => id).first
				if !treinador.nil?
					puts "Você escolheu o treinador "+treinador.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite o novo numero de insignias que deseja atribuir ao treinador '+treinador.name+' (valor atual: '+treinador.badges.to_s+'):'
						novasbadges = gets.chomp.to_i
						puts "Confirma a mudança de '"+treinador.badges.to_s+"' para '"+novasbadges.to_s+"'?(s/n)"
						if gets.chomp=='s'
							treinador.update_attribute :badges, novasbadges
							puts "Insignias alteradas com sucesso!"
							alterou = true
							gets #EsperaEnter
						else
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe treinador com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 4
			while !alterou
				puts 'Digite a ID do Treinador:'
				id = gets.chomp.to_i
				treinador = Trainer.where(:id => id).first
				puts "Você escolheu o treinador "+treinador.name+"?(s/n)"
				if !treinador.nil?
					puts "Você escolheu o treinador "+treinador.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						if treinador.bag.nil?
							puts "O treinador "+treinador.name+" não possui mochila. Deseja inserir uma agora? (s/n)"
							if gets.chomp=='s'
								mochila = treinador.build_bag
								mochila.inserir
								alterou=true
							end
						else
							mochila = treinador.bag
							puts 'Digite a nova quantidade de Pokebolas do treinador '+treinador.name+' (valor atual: '+mochila.pokeballs.to_s+'):'
							novaspkballs = gets.chomp.to_i
							puts "Confirma a mudança de "+mochila.pokeballs.to_s+" Pokebolas para "+novaspkballs.to_s+" Pokebolas?(s/n)"
							if gets.chomp=='s'
								mochila.update_attribute :pokeballs, novaspkballs
								puts "Pokebolas alteradas com sucesso!"
								puts 'Digite a nova quantidade de Poções do treinador '+treinador.name+' (valor atual: '+mochila.potions.to_s+'):'
								novaspocoes = gets.chomp.to_i
								puts "Confirma a mudança de "+mochila.potions.to_s+" Poções para "+novaspocoes.to_s+" Poções?(s/n)"
								if gets.chomp=='s'
									mochila.update_attribute :potions, novaspocoes
									puts "Poções alteradas com sucesso!"
									alterou = true
								else
									puts 'Deseja tentar novamente? (s/n)'
									if gets.chomp=='n'
										alterou = true
									end
								end
							else
								puts 'Deseja tentar novamente? (s/n)'
								if gets.chomp=='n'
									alterou = true
								end
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe treinador com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		else
			puts 'Opção Inválida!'
		end
	end
end

class Pokemon < ActiveRecord::Base;
	belongs_to	:trainer
	has_and_belongs_to_many	:moves

	def inserir
		puts 'Digite o nome do Pokemon:'
		self.name = gets.chomp
		puts 'Digite o número de '+self.name+' na Pokedex:'
		self.pokedex_number = gets.chomp.to_i
		puts 'A qual tipo o pokemon '+self.name+' pertence?'
		self.poketype = gets.chomp
		if self.trainer_id==nil
			associou=false
			puts 'Deseja associa-lo a um treinador? (s/n)'
			if gets.chomp.downcase == "s"
				associou=false
				while !associou
					puts 'Qual a ID do treinador a quem pertence esse pokemon?' 
					puts '(Caso precise pesquisar uma ID, digite \'pesquisar\'.)'
					resposta = gets.chomp
					if resposta == 'pesquisar'
						treinador = Trainer.new()
						treinador.pesquisar(2)
					else
						if Trainer.exists?(resposta.to_i)
							self.trainer_id = resposta.to_i
							associou=true
							puts "Pokemon associado com sucesso!"
							gets #EsperaEnter
						else
							puts "Não existe treinador com essa ID"
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								associou = true
							end
						end
					end
				end
			end
		end
		self.n_moves = 0
		puts 'Agora vamos inserir as habilidades deste Pokemon.'
		puts 'Cada Pokemon pode ter no máximo 4 habilidades.'
		puts 'O Pokemon '+self.name+' possui '+self.n_moves.to_s+' habilidades.'
		puts 'Deseja inserir uma nova habilidade agora? (s/n)'
		self.save
		while (self.n_moves<5) && (gets.chomp.downcase =='s')
			puts 'Digite o nome da habilidade:'
			movename = gets.chomp.downcase
			habilidade = Move.where(:name => movename)
			if habilidade.length>0
				self.moves << (habilidade.first)
				self.n_moves+=1
				puts "Habilidade "+habilidade.first.name.capitalize+" inserida com sucesso!"
				gets	#EsperaEnter
			else
				habilidade = Move.new(:name => movename)
				habilidade.inserir
				self.n_moves+=1
				self.moves << (habilidade)
			end
			if self.n_moves<4
				puts 'Deseja inserir mais uma habilidade? (s/n)'
				puts '(Quantidade atual de habilidades: '+self.n_moves.to_s+'/4.)'
			end
		end
		self.save
		puts "Pokemon "+self.name+" inserido com Sucesso!"
		gets	#EsperaEnter
	end

	def remover
		puts 'Digite a ID do Pokemon: '
		puts '(Se você não sabe a ID do Pokemon, digite \'cancelar\' e use a opção de exibição.)'
		id = gets.chomp
		if id != 'cancelar'
			id = id.to_i
			pokemon = Pokemon.where(:id => id)
			if pokemon.length>0
				puts 'Você tem certeza que deseja excluir o pokemon '+pokemon[0].name+'? (s/n)'
				if (gets.chomp.downcase == 's')
					nome = pokemon[0].name
					pokemon.destroy_all
					puts 'O Pokemon '+nome+' foi excluido com sucesso.'
					gets #EsperaEnter
				end
			else
				puts 'A ID digitada não existe'
				gets #EsperaEnter
			end
		end
	end

	def listartodos
		pokemons = Pokemon.all;
		if pokemons.length==0
			puts 'Nenhum pokemon registrado.'
		end
		pokemons.each do |t|
			t.me_imprima
		end
		gets	#EsperaEnter
	end

	def me_imprima
		puts ("ID: "+self.id.to_s)
		puts ("Nome: "+self.name)
		puts ("Número na Pokedex: "+self.pokedex_number.to_s)
		puts ("Tipo: "+self.poketype)
		printf ("ID do seu treinador: ")
		if (self.trainer_id.nil?)
			puts 'Sem Treinador'
		else
			puts self.trainer_id.to_s
		end
		puts ("Quantidade de Habilidades: "+self.n_moves.to_s)
		if n_moves!=0
			puts "Habilidades:"
			habilidades = self.moves
			habilidades.each do |m|
				printf "\t"
				puts m.name
			end
		else
			puts 'Sem habilidades'
		end
		puts ("--------------------")
	end

	def pesquisar(op)
		encontrou = false
		case op
		when 2
			while (not encontrou)
				puts 'Digite o nome do Pokemon:'
				nome = gets.chomp
				pokemons = Pokemon.where(:name => nome)
				if pokemons != nil
					pokemons.each do |t|
						t.me_imprima
					end
				else
					puts 'O pokemon '+nome+' não existe!'
				end
				puts 'Deseja pesquisar novamente? (s/n)'
				p = gets.chomp
				if p=='n'
					encontrou = true
				end
			end
		when 3
			while !encontrou
				puts 'Digite o número da pokedex do pokemon:'
				pokedex_number = gets.chomp
				pokemons = Pokemon.where(:pokedex_number => pokedex_number)
				if pokemons != nil
					pokemons.each do |t|
						t.me_imprima
					end
				else
					puts 'Não existe um pokemon o número de Pokedex \''+pokedex_number.to_i+'\'.'
				end
				puts 'Deseja pesquisar novamente? (s/n)'
				p = gets.chomp
				if p=='n'
					encontrou = true
				end
			end
		when 4
			while !encontrou
				puts 'Digite o tipo do pokemon:'
				tipo = gets.chomp
				pokemons = Pokemon.where(:poketype => tipo)
				if pokemons != nil
					pokemons.each do |t|
						t.me_imprima
					end
				else
					puts 'Não existe um pokemon do tipo '+tipo+'.'
				end
				puts 'Deseja pesquisar novamente? (s/n)'
				p = gets.chomp
				if p=='n'
					encontrou = true
				end
			end
		when 5
			while !encontrou
				puts 'Digite o nome do treinador:'
				nome = gets.chomp
				treinadores = Trainer.where(:name => nome)
				if treinadores != nil
					treinadores.each do |t|
						t.exibe_pokemons
					end
				else
					puts 'Não existe um treinador chamado '+nome+'.'
				end
				puts 'Deseja pesquisar novamente? (s/n)'
				p = gets.chomp
				if p=='n'
					encontrou = true
				end
			end
		else
			puts 'Opção Inválida!'
		end
	end

	def atualizar(op)
		alterou = false
		case op
		when 1
			while !alterou
				puts 'Digite a ID do Pokemon:'
				id = gets.chomp.to_i
				pokemon = Pokemon.where(:id => id).first
				if !pokemon.nil?
					puts "Você escolheu o Pokemon "+pokemon.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite o novo nome que deseja atribuir ao pokemon '+pokemon.name+':'
						novonome = gets.chomp
						puts "Confirma a mudança de '"+pokemon.name+"' para '"+novonome+"'?(s/n)"
						if gets.chomp=='s'
							pokemon.update_attribute :name, novonome
							puts "Nome alterado com sucesso!"
							alterou = true
							gets	#EsperaEnter
						else
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true
					end
				else
					puts "Não existe pokemon com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 2
			while !alterou
				puts 'Digite a ID do Pokemon:'
				id = gets.chomp.to_i
				pokemon = Pokemon.where(:id => id).first
				if !pokemon.nil?
					puts "Você escolheu o Pokemon "+pokemon.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite o novo numero na Pokedex que deseja atribuir ao pokemon '+pokemon.name+' (valor atual: '+pokemon.pokedex_number.to_s+'):'
						novapokedex = gets.chomp.to_i
						puts "Confirma a mudança de '"+pokemon.pokedex_number.to_s+"' para '"+novapokedex.to_s+"'?(s/n)"
						if gets.chomp=='s'
							pokemon.update_attribute :pokedex_number, novapokedex
							puts "Número na Pokedex alterado com sucesso!"
							alterou = true
							gets	#EsperaEnter
						else
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true
					end
				else
					puts "Não existe pokemon com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 3
			while !alterou
				puts 'Digite a ID do pokemon:'
				id = gets.chomp.to_i
				pokemon = Pokemon.where(:id => id).first
				if !pokemon.nil?
					puts "Você escolheu o Pokemon "+pokemon.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite o novo tipo que deseja atribuir ao pokemon '+pokemon.name+' (tipo atual: '+pokemon.poketype+'):'
						novotipo = gets.chomp
						puts "Confirma a mudança de '"+pokemon.poketype+"' para '"+novotipo+"'?(s/n)"
						if gets.chomp=='s'
							pokemon.update_attribute :poketype, novotipo
							puts "Tipo alterado com sucesso!"
							alterou = true
							gets	#EsperaEnter
						else
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe pokemon com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 4
			while !alterou
				puts 'Digite a ID do pokemon:'
				id = gets.chomp.to_i
				pokemon = Pokemon.where(:id => id).first
				if !pokemon.nil?
					puts "Você escolheu o Pokemon "+pokemon.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						if pokemon.moves.nil?
							puts "O pokemon "+pokemon.name+" não possui nenhuma habilidade ainda. Deseja inserir uma agora? (s/n)"
							while (pokemon.n_moves<4) && (gets.chomp.downcase =='s')
								habilidade = Move.new
								habilidade.inserir
								pokemon.n_moves+=1
								pokemon.moves << (habilidade)
								if pokemon.n_moves<4
									puts 'Deseja inserir mais uma habilidade? (s/n)'
									puts '(Quantidade atual de habilidades: '+pokemon.n_moves.to_s+'/4.)'
								end
							end
							alterou=true
						else
							habilidades = pokemon.moves
							puts "Habilidades:"
							habilidades.each do |m|
								printf "\t"
								puts 'ID: '+m.id.to_s
								printf "\t"
								puts 'Nome: '+m.name
								printf "\t"
								puts 'Tipo: '+m.movetype
								printf "\t"
								puts 'Categoria: '+m.category
								puts
							end
							puts "Digite a ID correspondente a habilidade que deseja alterar"
							moveid = gets.chomp.to_i
							habilidade = Move.where(:id => moveid)
							if habilidade.length>0
								menuAtualizarHabilidade
								opAlteraHabilidade = gets.chomp.to_i
								while opAlteraHabilidade != 4
									case opAlteraHabilidade
										when 1
											puts habilidade.first.inspect
											puts "Digite o novo nome que deseja atribuir a habilidade "+habilidade.first.name
											novonome = gets.chomp.downcase
											puts "Confirma a mudança de "+habilidade.first.name+" para "+novonome+"?(s/n)"
											if gets.chomp == 's'
												habilidade.first.update_attribute :name, novonome
												puts "Nome alterado com sucesso!"
												alterou = true
												gets #EsperaEnter
											end
										when 2
											puts "Digite o novo tipo que deseja atribuir a habilidade "+habilidade.first.name+". (tipo atual: "+habilidade.first.movetype+")"
											novotipo = gets.chomp.downcase
											puts "Confirma a mudança de "+habilidade.first.movetype+" para "+novotipo+"?(s/n)"
											if gets.chomp == 's'
												habilidade.first.update_attribute :movetype, novotipo
												puts "Tipo alterado com sucesso!"
												alterou = true
												gets #EsperaEnter
											end
										when 3
											puts "Digite a nova categoria que deseja atribuir a habilidade "+habilidade.first.name+". (categoria atual: "+habilidade.first.category+")"
											puts '(Categorias válidas: Physical, Special, ou Status.)'
											categoriainvalida=true
											while categoriainvalida
												novacategoria = gets.chomp.downcase
												if (novacategoria != 'physical') &&  (novacategoria != 'special') && (novacategoria != 'status')
													puts 'Categoria Inválida!'
												else
													categoriainvalida=false
												end
											end
											puts "Confirma a mudança de "+habilidade.first.category+" para "+novacategoria+"?(s/n)"
											if gets.chomp == 's'
												habilidade.first.update_attribute :category, novacategoria
												puts "Categoria alterada com sucesso!"
												alterou = true
												gets #EsperaEnter
											end
										else
											puts 'Opção Inválida!'
											gets	# EsperaEnter
									end
									menuAtualizarHabilidade
									opAlteraHabilidade = gets.chomp.to_i
								end
								alterou = true
							else
								puts 'Deseja tentar novamente? (s/n)'
								if gets.chomp=='n'
									alterou = true
								end
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe pokemon com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		when 5
			while !alterou
				puts 'Digite a ID do Pokemon:'
				id = gets.chomp.to_i
				pokemon = Pokemon.where(:id => id).first
				if !pokemon.nil?
					puts "Você escolheu o Pokemon "+pokemon.name+"?(s/n)"
					if gets.chomp.downcase=="s"
						puts 'Digite a ID do treinador que deseja associar ao pokemon '+pokemon.name+':'
						printf "Treinador atual: "
						if pokemon.trainer_id.nil?
							puts "Sem Treinador."
						else
							puts pokemon.trainer.name
						end
						novotreinadorid = gets.chomp.to_i
						if Trainer.exists?(novotreinadorid)
							novotreinador = Trainer.where(:id => novotreinadorid).first
							puts "Confirma '"+novotreinador.name+"' como o novo treinador de "+pokemon.name+"?(s/n)"
							if gets.chomp=='s'
								pokemon.update_attribute :trainer_id, novotreinadorid
								puts "Treinador alterado com sucesso!"
								alterou = true
								gets #EsperaEnter
							else
								puts 'Deseja tentar novamente? (s/n)'
								if gets.chomp=='n'
									alterou = true
								end
							end
						else
							puts "Não existe treinador com essa ID"
							puts 'Deseja tentar novamente? (s/n)'
							if gets.chomp=='n'
								alterou = true
							end
						end
					else
						alterou = true;
					end
				else
					puts "Não existe pokemon com essa ID."
					alterou = true
					gets #EsperaEnter
				end
			end
		else
			puts 'Opção Inválida!'
		end
	end
end

class Move < ActiveRecord::Base;
	has_and_belongs_to_many :pokemons

	def inserir
		puts 'Digite o tipo da habilidade:'
		self.movetype = gets.chomp
		categoriainvalida=true
		while categoriainvalida
			puts 'Digite a categoria da habilidade: '
			puts '(Categorias válidas: Physical, Special, ou Status.)'
			self.category = gets.chomp.downcase
			if (self.category != 'physical') &&  (self.category != 'special') && (self.category != 'status')
				puts 'Categoria Inválida!'
			else
				categoriainvalida=false
			end
		end
		puts 'Habilidade '+self.name.capitalize+' inserida com sucesso!'
		gets	#EsperaEnter
		self.save
	end
end

class Bag < ActiveRecord::Base;
	belongs_to :trainer

	def inserir
		puts 'Digite o número de Pokebolas que estão na mochila:'
		self.pokeballs = gets.to_i
		puts 'Digite o número de Poções que estão na mochila:'
		self.potions = gets.to_i
		self.save
		puts self.pokeballs.to_s+' Pokebolas e '+self.potions.to_s+' Poções armazenadas com sucesso na Mochila!'
	end
end

class MovesPokemon < ActiveRecord::Base;
	belongs_to	:pokemons
	belongs_to	:moves
end

#menus {
	def menuPrincipal
		system ("clear");
		printf ("\t+-------------------Gerenciador Pokemon--------------------+\n")
		printf ("\t| '/'                                                      |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Inserir.                                         |\n")
		printf ("\t|     (2) Exibir.                                          |\n")
		printf ("\t|     (3) Atualizar.                                       |\n")
		printf ("\t|     (4) Remover.                                         |\n")
		printf ("\t|     (5) Sair.                                            |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuInserir
		system ("clear");
		printf ("\t+-----------------O que voce deseja inserir?---------------+\n")
		printf ("\t| '/Inserir'                                               |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Treinador.                                       |\n")
		printf ("\t|     (2) Pokemon.                                         |\n")
		printf ("\t|     (3) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuExibir
		system ("clear");
		printf ("\t+-----------------O que voce deseja exibir?----------------+\n")
		printf ("\t| '/Exibir'                                                |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Treinador.                                       |\n")
		printf ("\t|     (2) Pokemon.                                         |\n")
		printf ("\t|     (3) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuExibirTreinador
		system ("clear");
		printf ("\t+----------------------Exibir Treinador--------------------+\n")
		printf ("\t| '/Exibir/Treinador'                                      |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Exibir todos os treinadores.                     |\n")
		printf ("\t|     (2) Pesquisar e exibir por nome.                     |\n")
		printf ("\t|     (3) Pesquisar e exibir por cidade.                   |\n")
		printf ("\t|     (4) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuExibirPokemon
		system ("clear");
		printf ("\t+-------------------------Exibir Pokemon-------------------+\n")
		printf ("\t| '/Exibir/Pokemon'                                        |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Exibir todos os Pokemons.                        |\n")
		printf ("\t|     (2) Pesquisar e exibir por nome.                     |\n")
		printf ("\t|     (3) Pesquisar e exibir por número da Pokedex.        |\n")
		printf ("\t|     (4) Pesquisar e exibir por tipo.                     |\n")
		printf ("\t|     (5) Pesquisar e exibir pelo nome do treinador.       |\n")
		printf ("\t|     (6) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuRemover
		system ("clear");
		printf ("\t+----------------O que voce deseja remover?----------------+\n")
		printf ("\t| '/Remover'                                               |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Treinador.                                       |\n")
		printf ("\t|     (2) Pokemon.                                         |\n")
		printf ("\t|     (3) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuAtualizar
		system ("clear");
		printf ("\t+--------------O que voce deseja atualizar?----------------+\n")
		printf ("\t| '/Atualizar'                                             |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Treinador.                                       |\n")
		printf ("\t|     (2) Pokemon.                                         |\n")
		printf ("\t|     (3) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuAtualizarTreinador
		system ("clear");
		printf ("\t+--------------O que você deseja atualizar?----------------+\n")
		printf ("\t| '/Atualizar/Treinador'                                   |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Nome.                                            |\n")
		printf ("\t|     (2) Cidade.                                          |\n")
		printf ("\t|     (3) Insígnias.                                       |\n")
		printf ("\t|     (4) Mochila.                                         |\n")
		printf ("\t|     (5) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuAtualizarPokemon
		system ("clear");
		printf ("\t+--------------O que você deseja atualizar?----------------+\n")
		printf ("\t| '/Atualizar/Pokemom'                                     |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Nome.                                            |\n")
		printf ("\t|     (2) Número na Pokedex.                               |\n")
		printf ("\t|     (3) Tipo.                                            |\n")
		printf ("\t|     (4) Habilidades.                                     |\n")
		printf ("\t|     (5) Treinador.                                       |\n")
		printf ("\t|     (6) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end

	def menuAtualizarHabilidade
		system ("clear");
		printf ("\t+--------------O que você deseja atualizar?----------------+\n")
		printf ("\t| '/Atualizar/Pokemon/Habilidade'                          |\n")
		printf ("\t|                                                          |\n")
		printf ("\t|     (1) Nome.                                            |\n")
		printf ("\t|     (2) Tipo.                                            |\n")
		printf ("\t|     (3) Categoria.                                       |\n")
		printf ("\t|     (4) Voltar ao menu anterior.                         |\n")
		printf ("\t|                                                          |\n")
		printf ("\t+----------------------------------------------------------+\n")
		printf ("? ");
	end
#}

#main {
	#objetos genericos
	treinador = Trainer.new()
	pokemon = Pokemon.new()
	habilidade = Move.new()
	menuPrincipal
	opPrincipal = gets.chomp.to_i
	while opPrincipal!=5
		case opPrincipal
			when 1	#Inserir
				menuInserir
				opInserir = gets.chomp.to_i
				while opInserir!=3
					case opInserir
						when 1	#Inserir Treinador
							treinador = Trainer.new()
							treinador.inserir
						when 2	#Inserir Pokemon
							pokemon = Pokemon.new()
							pokemon.inserir
						else 	#Voltar
							puts 'Opção Inválida!'
					end
					menuInserir
					opInserir = gets.chomp.to_i
				end
			when 2	#Exibir
				menuExibir
				opExibir = gets.chomp.to_i
				while opExibir!=3
					case opExibir
						when 1	#Treinador
							menuExibirTreinador
							opExibirTreinador = gets.chomp.to_i
							while opExibirTreinador != 4
								case opExibirTreinador
									when 1	#Exibir todos
										treinador.listartodos
									when 2	#Por nome
										treinador.pesquisar(2)
									when 3	#Por Cidade
										treinador.pesquisar(3)
									else 	#Voltar
										puts 'Opção Inválida!'
										gets	# EsperaEnter
								end
								menuExibirTreinador
								opExibirTreinador = gets.chomp.to_i
							end
						when 2	#Pokemon
							menuExibirPokemon
							opExibirPokemon = gets.chomp.to_i
							while opExibirPokemon != 6
								case opExibirPokemon
									when 1
										pokemon.listartodos		#Exibir Todos
									when 2
										pokemon.pesquisar(2)	#Por Nome
									when 3
										pokemon.pesquisar(3)	#Por Pokedex
									when 4
										pokemon.pesquisar(4)	#Por Tipo
									when 5
										pokemon.pesquisar(5)	#Por Treinador
									else
										puts 'Opção Inválida!'
										gets	# EsperaEnter
								end
								menuExibirPokemon
								opExibirPokemon = gets.chomp.to_i
							end
						else
							puts "Opção Inválida!"
							gets	# EsperaEnter
					end
					menuExibir
					opExibir = gets.chomp.to_i	
				end
			when 3	#Atualizar
				menuAtualizar
				opAtualizar = gets.chomp.to_i
				while opAtualizar!=3
					case opAtualizar
						when 1	#Atualizar Treinador
							menuAtualizarTreinador
							opAtualizarTreinador = gets.chomp.to_i
							while opAtualizarTreinador != 5
								case opAtualizarTreinador
									when 1
										treinador.atualizar(1)	#Atualizar Nome
									when 2
										treinador.atualizar(2)	#Atualizar Cidade
									when 3
										treinador.atualizar(3)	#Atualizar insignias
									when 4
										treinador.atualizar(4)	#Atualizar mochila
									else 	#voltar
										puts 'Opção Inválida!'
										gets	# EsperaEnter
								end
								menuAtualizarTreinador
								opAtualizarTreinador= gets.chomp.to_i
							end
						when 2	#Atualizar Pokemon
							menuAtualizarPokemon
							opAtualizarPokemon = gets.chomp.to_i
							while opAtualizarPokemon != 6
								case opAtualizarPokemon
									when 1
										pokemon.atualizar(1)	#Atualizar Nome
									when 2
										pokemon.atualizar(2)	#Atualizar Número na Pokedex
									when 3
										pokemon.atualizar(3)	#Atualizar Tipo
									when 4
										pokemon.atualizar(4)	#Atualizar Habilidades
									when 5
										pokemon.atualizar(5)	#Atualizar Treinador
									else 	#voltar
										puts 'Opção Inválida!'
										gets	# EsperaEnter
								end
								menuAtualizarPokemon
								opAtualizarPokemon= gets.chomp.to_i
							end
						else 	#Voltar
							puts 'Opção Inválida!'
					end
					menuAtualizar
					opAtualizar = gets.chomp.to_i
				end
			when 4	#Remover
				menuRemover
				opRemover = gets.chomp.to_i
				while opRemover!=3
					case opRemover
						when 1	#Remover Treinador
							treinador.remover
						when 2	#Remover Pokemon
							pokemon.remover
						else 	#Voltar
							puts 'Opção Inválida!'
					end
					menuRemover
					opRemover = gets.chomp.to_i
				end
			else
				puts "Opção Inválida!"
		end
		menuPrincipal
		opPrincipal = gets.chomp.to_i
	end
#}