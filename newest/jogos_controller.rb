class JogosController < ApplicationController

  def home
    Card.all.select{|cd| cd.number != 0}.each do |c|
      c.number = 0
      c.save
    end
    Deck.all.select{|dc| dc.number != 0}.each do |d|
      d.number = 0
      d.save
    end
  end

  def card
    @cards = Card.all
    @cardorgs = Deck.all
    if params[:id].nil?
      @card = 0
    elsif params[:id].include?("SIORG")
      @card = Deck.find_by(identificacao: params[:id])
    else
      @card = Card.find(params[:id])
    end
  end

  def intermedium
    if params[:card].nil? == false
      redirect_to "/card/#{params[:card]}"
    else
      redirect_to "/card/#{params[:deck]}"
    end
  end

  def game
    @player1 = Player.new(nome: params[:player1], nature: "human")
    @player1.save
    @player2 = Player.new(nome: "Oponente", nature: "computer")
    @player2.save
    @game = Game.new(player1: @player1.id, player2: @player2.id)
    @game.save
    if params[:deck_cartas] == "servico"
      @cards = Card.all
    else
      @cards = Deck.all
    end
    @stack1 = []
    @stack2 = []
    until @stack1.size == 12
      card = @cards.sample.id
      if @stack1.include?(card) == false
        @stack1 << card
      end
    end
    until @stack2.size == 12
      card2 = @cards.sample.id
      if @stack1.include?(card2) == false && @stack2.include?(card2) == false
        @stack2 << card2
      end
    end
    @hand = Hand.new(game_id: @game.id)
    @hand.save
    @stackp1 = Stack.new(game_id: @game.id, player_id: @player1.id, cards: @stack1)
    @stackp2 = Stack.new(game_id: @game.id, player_id: @player2.id, cards: @stack2)
    @stackp1.save
    @stackp2.save
  end

  def hand
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @stack1 = Stack.find_by(game_id: @game.id, player_id: @game.player1)
    @stack2 = Stack.find_by(game_id: @game.id, player_id: @game.player2)
    @player1 = Player.find(@stack1.player_id)
    @player2 = Player.find(@stack2.player_id)
    @cards_txt1 = @stack1.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @cards_txt2 = @stack2.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @st1 = @cards_txt1.split(",").map{|x| x.to_i}
    @st2 = @cards_txt2.split(",").map{|x| x.to_i}
    n1 = []
    @st1.each do |s|
      n1 << Card.find(s.to_i).number
    end
    n2 = []
    @st2.each do |s|
      n2 << Card.find(s.to_i).number
    end
    @cst1 = @st1.select{|s| Card.find(s.to_i).number == n1.min}
    @cst2 = @st2.select{|s| Card.find(s.to_i).number == n2.min}
    @hand.cardp1 = @cst1.sample
    @hand.cardp2 = @cst2.sample
    @hand.save
    @card = Card.find(@hand.cardp1.to_i)
    @card.number += 1
    @card.save
    @cardadv = Card.find(@hand.cardp2.to_i)
    @cardadv.number += 1
    @cardadv.save
    @opts = ["total_de_avaliacoes", "aprovacao_do_servico", "quantidade_de_etapas", "indice_de_digitalizacao", "botao_iniciar", "tempo_de_espera", "total_de_avaliacoes", "aprovacao_do_servico", "quantidade_de_etapas", "indice_de_digitalizacao", "botao_iniciar", "tempo_de_espera"]
    if @cardadv.avaliacoes < 10
      @opts = @opts - ["total_de_avaliacoes"]
    end
    if @cardadv.aprovacao < 0.5
      @opts = @opts - ["aprovacao_do_servico"]
    end
    if @cardadv.etapas > 3
      @opts = @opts - ["quantidade_de_etapas"]
    end
    if @cardadv.digitalizacao < 50
      @opts = @opts - ["indice_de_digitalizacao"]
    end
    if @cardadv.botao_iniciar == false
      @opts = @opts - ["botao_iniciar"]
    end
    if @cardadv.duracao > 10
      @opts = @opts - ["tempo_de_espera"]
    end
    @compchar = @opts.sample
  end

  def handorg
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @stack1 = Stack.find_by(game_id: @game.id, player_id: @game.player1)
    @stack2 = Stack.find_by(game_id: @game.id, player_id: @game.player2)
    @player1 = Player.find(@stack1.player_id)
    @player2 = Player.find(@stack2.player_id)
    @cards_txt1 = @stack1.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @cards_txt2 = @stack2.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @st1 = @cards_txt1.split(",").map{|x| x.to_i}
    @st2 = @cards_txt2.split(",").map{|x| x.to_i}
    n1 = []
    @st1.each do |s|
      n1 << Deck.find(s.to_i).number
    end
    n2 = []
    @st2.each do |s|
      n2 << Deck.find(s.to_i).number
    end
    @cst1 = @st1.select{|s| Deck.find(s.to_i).number == n1.min}
    @cst2 = @st2.select{|s| Deck.find(s.to_i).number == n2.min}
    @hand.cardp1 = @cst1.sample
    @hand.cardp2 = @cst2.sample
    @hand.save
    @card = Deck.find(@hand.cardp1.to_i)
    @card.number += 1
    @card.save
    @cardadv = Deck.find(@hand.cardp2.to_i)
    @cardadv.number += 1
    @cardadv.save
    @opts = ["numero_de_servicos", "total_de_avaliacoes", "aprovacao_do_servico", "quantidade_de_etapas", "indice_de_digitalizacao", "botao_iniciar", "tempo_de_espera", "nao_estimado", "numero_de_servicos", "total_de_avaliacoes", "aprovacao_do_servico", "quantidade_de_etapas", "indice_de_digitalizacao", "botao_iniciar", "tempo_de_espera", "nao_estimado"]
    if @cardadv.cards.size < 10
      @opts = @opts - ["numero_de_servicos"]
    end
    if @cardadv.avaliacoes < 100
      @opts = @opts - ["total_de_avaliacoes"]
    end
    if @cardadv.aprovacao < 0.5
      @opts = @opts - ["aprovacao_do_servico"]
    end
    if @cardadv.media_etapas > 3
      @opts = @opts - ["quantidade_de_etapas"]
    end
    if @cardadv.digitalizacao < 50
      @opts = @opts - ["indice_de_digitalizacao"]
    end
    if @cardadv.porc_botao_iniciar < 0.5
      @opts = @opts - ["botao_iniciar"]
    end
    if @cardadv.media_duracao > 10
      @opts = @opts - ["tempo_de_espera"]
    end
    if @cardadv.qtd_nao_estimados > 3
      @opts = @opts - ["nao_estimado"]
    end
    @compchar = @opts.sample
  end

  def result
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @card1 = Card.find(@hand.cardp1)
    @card2 = Card.find(@hand.cardp2)
    @stack1 = Stack.find_by(game_id: @game.id, player_id: @game.player1)
    @stack2 = Stack.find_by(game_id: @game.id, player_id: @game.player2)
    @cards_txt1 = @stack1.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @cards_txt2 = @stack2.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @st1 = @cards_txt1.split(",").map{|x| x.to_i}
    @st2 = @cards_txt2.split(",").map{|x| x.to_i}
    if params[:caracteristica] == "total_de_avaliacoes"
      @char1 = @card1.avaliacoes.nil? ? 0 : @card1.avaliacoes
      @char2 = @card2.avaliacoes.nil? ? 0 : @card2.avaliacoes
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "aprovacao_do_servico"
      @char1 = @card1.aprovacao.nil? ? 0 : @card1.aprovacao
      @char2 = @card2.aprovacao.nil? ? 0 : @card2.aprovacao
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "quantidade_de_etapas"
      @char1 = @card1.etapas
      @char2 = @card2.etapas
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "indice_de_digitalizacao"
      @char1 = @card1.digitalizacao.nil? ? 0 : @card1.digitalizacao
      @char2 = @card2.digitalizacao.nil? ? 0 : @card2.digitalizacao
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "botao_iniciar"
      @char1 = @card1.botao_iniciar == true ? "Sim" : "Não"
      @char2 = @card2.botao_iniciar == true ? "Sim" : "Não"
      if @char1 == "Sim"
        if @char2 == "Não"
          @hand.winner = @game.player1
          @st1 << @hand.cardp2
          @st2 = @st2 - [@hand.cardp2]
        else
          @hand.winner = 0
        end
      else
        if @char2 == "Sim"
          @hand.winner = @game.player2
          @st1 = @st1 - [@hand.cardp1]
          @st2 << @hand.cardp1
        else
          @hand.winner = 0
        end
      end
    else params[:caracteristica] == "tempo_de_espera"
      @char1 = @card1.duracao
      @char2 = @card2.duracao
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    end
    @stack1.cards = @st1.to_s
    @stack2.cards = @st2.to_s
    @stack1.save
    @stack2.save
  end

  def resultorg
    @hand = Hand.find(params[:id])
    @game = @hand.game
    @card1 = Deck.find(@hand.cardp1)
    @card2 = Deck.find(@hand.cardp2)
    @stack1 = Stack.find_by(game_id: @game.id, player_id: @game.player1)
    @stack2 = Stack.find_by(game_id: @game.id, player_id: @game.player2)
    @cards_txt1 = @stack1.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @cards_txt2 = @stack2.cards.gsub("[","").gsub("]","").gsub(", ",",")
    @st1 = @cards_txt1.split(",").map{|x| x.to_i}
    @st2 = @cards_txt2.split(",").map{|x| x.to_i}
    if params[:caracteristica] == "total_de_avaliacoes"
      @char1 = @card1.avaliacoes.nil? ? 0 : @card1.avaliacoes
      @char2 = @card2.avaliacoes.nil? ? 0 : @card2.avaliacoes
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "numero_de_servicos"
      @char1 = @card1.cards.size
      @char2 = @card2.cards.size
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "nao_estimado"
      @char1 = @card1.qtd_nao_estimados.nil? ? 0 : @card1.qtd_nao_estimados
      @char2 = @card2.qtd_nao_estimados.nil? ? 0 : @card2.qtd_nao_estimados
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "aprovacao_do_servico"
      @char1 = @card1.aprovacao.nil? ? 0 : @card1.aprovacao
      @char2 = @card2.aprovacao.nil? ? 0 : @card2.aprovacao
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "quantidade_de_etapas"
      @char1 = @card1.media_etapas
      @char2 = @card2.media_etapas
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "indice_de_digitalizacao"
      @char1 = @card1.digitalizacao.nil? ? 0 : @card1.digitalizacao
      @char2 = @card2.digitalizacao.nil? ? 0 : @card2.digitalizacao
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    elsif params[:caracteristica] == "botao_iniciar"
      @char1 = @card1.porc_botao_iniciar.nil? ? 0 : @card1.porc_botao_iniciar
      @char2 = @card2.porc_botao_iniciar.nil? ? 0 : @card2.porc_botao_iniciar
      if @char1 < @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 > @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    else params[:caracteristica] == "tempo_de_espera"
      @char1 = @card1.media_duracao
      @char2 = @card2.media_duracao
      if @char1 > @char2
        @hand.winner = @game.player2
        @st1 = @st1 - [@hand.cardp1]
        @st2 << @hand.cardp1
      elsif @char1 < @char2
        @hand.winner = @game.player1
        @st1 << @hand.cardp2
        @st2 = @st2 - [@hand.cardp2]
      else
        @hand.winner = 0
      end
    end
    @stack1.cards = @st1.to_s
    @stack2.cards = @st2.to_s
    @stack1.save
    @stack2.save
  end

  def final_jogo
    @game = Game.find(params[:id])
  end

  def regras
  end

  def rascunho
  end

end

