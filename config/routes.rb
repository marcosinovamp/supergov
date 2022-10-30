Rails.application.routes.draw do
  root to: 'jogos#home'
  get 'card/:id', to: 'jogos#card'
  get 'card', to: 'jogos#card'
  get 'intermedium', to: 'jogos#intermedium'
  get 'rascunho', to: 'jogos#rascunho'
  get 'game', to: 'jogos#game'
  get 'hand/:id', to: 'jogos#hand'
  get 'handorg/:id', to: 'jogos#handorg'
  get 'result/:id', to: 'jogos#result'
  get 'resultorg/:id', to: 'jogos#resultorg'
  get 'final_jogo/:id', to: 'jogos#final_jogo'
  get 'regras', to: 'jogos#regras'
end