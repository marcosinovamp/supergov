require "csv"
require "json"
require "open-uri"

url = "https://www.servicos.gov.br/api/v1/servicos"
rascunho = URI.open(url).read
servicos = JSON.parse(rascunho)

ids = []
servicos["resposta"].each do |s|
    if Deck.find_by(siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "").to_i).nil?
        @org = Deck.new({nome:s["orgao"]["nomeOrgao"], siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "").to_i, number: 0, logo: "/#{s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "").to_i}.png", sigla: s["orgao"]["nomeOrgao"][(s["orgao"]["nomeOrgao"].index("(")+1)..(s["orgao"]["nomeOrgao"].index(")")-1)], identificacao: "SIORG#{s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "")}"})
    else
        @org = Deck.find_by(siorg:s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "").to_i)
    end
    @org.save
    if Card.find_by(api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "").to_i).nil?
        @card = Card.new(nome:s["nome"], api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "").to_i, deck_id:Deck.find_by(siorg: s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "").to_i).id, number: 0, identificacao: "#{Deck.find_by(siorg: s["orgao"]["id"].gsub("http://estruturaorganizacional.dados.gov.br/id/unidade-organizacional/", "").to_i).sigla}#{s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "")}")
    else
        @card = Card.find_by(api_id:s["id"].gsub("https://servicos.gov.br/api/v1/servicos/", "").to_i)
    end
    @card.digitalizacao = s["porcentagemDigital"]
    @card.botao_iniciar = s["servicoDigital"]
    pos = s["avaliacoes"]["positivas"].nil? ? 0 : s["avaliacoes"]["positivas"].to_i
    neg = s["avaliacoes"]["negativas"].nil? ? 0: s["avaliacoes"]["negativas"].to_i
    tot = pos + neg
    @card.aprovacao = tot == 0 ? 0 : (pos.to_f/tot)
    @card.avaliacoes = tot
    @card.etapas = s["etapas"].size
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
        @card.tempo = 999999
        @card.unidade = "dias"
    end
    if @card.unidade == "dias" || @card.unidade == "dias-corridos"
        @card.duracao = @card.tempo
    end
    if @card.unidade == "dias-uteis"
        @card.duracao = @card.tempo + ((@card.tempo/5)+2)
    end
    if @card.unidade == "minutos"
        @card.duracao = 0
    end
    if @card.unidade == "horas"
        if @card.tempo <= 12
            @card.duracao = 0
        elsif @card.tempo > 12 && @card.tempo <= 24
            @card.duracao = 1
        else
            @card.duracao = (@card.tempo.to_f/24).round
        end
    end
    if @card.unidade == "" || @card.unidade.nil?
        @card.duracao = 999999
    end
    if @card.unidade = "meses"
        @card.duracao = @card.tempo*30
    end
    @card.save
end
Deck.all.each do |d|
    @aval = 0
    @apv = 0
    @etp = 0
    @dig = 0
    @bi = 0
    @dur = 0
    @estimados = d.cards.select{|cd| cd.duracao < 999999}
    d.cards.each do |c|
        @aval += c.avaliacoes
        @apv += c.aprovacao
        @etp += c.etapas
        @dig += c.digitalizacao
        if c.botao_iniciar == true
            @bi += 1
        end
    end
    @estimados.each do |e|
        @dur += e.duracao
    end
    d.avaliacoes = @aval
    d.aprovacao = @apv.to_f/d.cards.size
    d.media_etapas = @etp.to_f/d.cards.size
    d.digitalizacao = @dig.to_f/d.cards.size
    d.porc_botao_iniciar = @bi.to_f/d.cards.size
    d.media_duracao = @dur.to_f/@estimados.size
    d.qtd_nao_estimados = d.cards.size - @estimados.size
    d.save
end