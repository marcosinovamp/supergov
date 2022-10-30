require "csv"
require "json"
require "open-uri"

url = "https://www.servicos.gov.br/api/v1/servicos"
rascunho = URI.open(url).read
servicos = JSON.parse(rascunho)

ids = []
servicos["resposta"].each do |s|
    if Deck.find_by(siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")).nil?
        @org = Deck.new({nome:s["orgao"]["nomeOrgao"], siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", ""), number: 0})
    else
        @org = Deck.find_by(siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", ""))
        @org.nome = s["orgao"]["nomeOrgao"]
        @org.siorg = s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")
        @org.number = 0
    end
    @org.save
    if Card.find_by(api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "")).nil?
        @card = Card.new(nome:s["nome"], api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", ""), deck_id:Deck.find_by(siorg: s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")).id, digitalizacao:s["porcentagemDigital"], botao_iniciar: s["servicoDigital"], etapas: s["etapas"].size)
    else
        @card = Card.find_by(api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", ""))
        @card.nome = s["nome"]
        @card.api_id = s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "")
        @card.deck_id = Deck.find_by(siorg: s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")).id
        @card.digitalizacao = s["porcentagemDigital"]
        @card.botao_iniciar = s["servicoDigital"]
        @card.etapas = s["etapas"].size
    end
    if s["tempoTotalEstimado"]["ate"].nil? == false
        @card.tempo = s["tempoTotalEstimado"]["ate"]["max"].to_i
        @card.unidade = s["tempoTotalEstimado"]["ate"]["unidade"]
    elsif s["tempoTotalEstimado"]["entre"].nil? == false
        @card.tempo = s["tempoTotalEstimado"]["entre"]["max"].to_i
        @card.unidade = s["tempoTotalEstimado"]["entre"]["unidade"]
    elsif s["tempoTotalEstimado"]["atendimentoImediato"].nil? == false
        @card.tempo = 0
        @card.unidade = "dias"
    else
        @card.tempo = 999999999
        @card.unidade = "dias"
    end
    if s["avaliacoes"].nil?
        @card.aprovacao = 0
        @card.avaliacoes = 0
    else
        pos = s["avaliacoes"]["positivas"].nil? ? 0 : s["avaliacoes"]["positivas"].to_i
        neg = s["avaliacoes"]["negativas"].nil? ? 0: s["avaliacoes"]["negativas"].to_i
        @card.aprovacao = pos.to_f/(pos + neg)
        @card.avaliacoes = pos + neg
    end
    if @card.aprovacao.nil?
        @card.aprovacao = 0
    end
    if @card.avaliacoes.nil?
        @card.avaliacoes = 0
    end
    if @card.digitalizacao.nil?
        @card.digitalizacao = 0
    end
    @card.save
end
# botão iniciar
@soma = 0
Deck.all.each do |d|
    d.cards.each do |c|
        if c.botao_iniciar == true
            @soma += 1
        end
    end
    d.porc_botao_iniciar = @soma.to_f/d.cards.size
    d.save
    @soma = 0
end
# duracao e não estimados
@soma = 0

Deck.all.each do |d|
    if d.media_duracao.nil?
        d.media_duracao = 999999999
        d.save
    end
    @estimados = d.cards.select{|cd| cd.media_duracao < 999999999}
    @estimados.each do |c|
        @soma += c.media_duracao
    end
    d.qtd_nao_estimados = d.cards.size - @estimados.size
    @tam = @estimados.size == 0 || @estimados.size.nil? ? 1 : @estimados.size
    d.media_duracao = @soma.to_f/@tam
    d.save
    @soma = 0
end
# digitalização
@soma = 0
Deck.all.each do |d|
    d.cards.each do |c|
        @soma += c.digitalizacao
    end
    d.digitalizacao = @soma.to_f/d.cards.size
    d.save
    @soma = 0
end
# etapas
@soma = 0
Deck.all.each do |d|
    d.cards.each do |c|
        @soma += c.etapas
    end
    d.media_etapas = @soma.to_f/d.cards.size
    d.save
    @soma = 0
end
# aprovação
@soma = 0
Deck.all.each do |d|
    d.cards.each do |c|
        @soma += c.aprovacao
    end
    d.aprovacao = @soma.to_f/d.cards.size
    d.save
    @soma = 0
end
#avaliações
@soma = 0
Deck.all.each do |d|
    d.cards.each do |c|
        @soma += c.avaliacoes
    end
    d.avaliacoes = @soma.to_f/d.cards.size
    d.save
    @soma = 0
end
# identificação
Deck.all.each do |d|
    d.identificacao = "SIORG#{d.id}"
end