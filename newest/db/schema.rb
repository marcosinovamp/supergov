# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_23_101532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cards", force: :cascade do |t|
    t.string "nome"
    t.float "digitalizacao"
    t.boolean "botao_iniciar"
    t.integer "api_id"
    t.float "aprovacao"
    t.integer "avaliacoes"
    t.integer "etapas"
    t.integer "tempo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "unidade"
    t.integer "duracao"
    t.bigint "deck_id"
    t.string "identificacao"
    t.integer "number"
    t.index ["deck_id"], name: "index_cards_on_deck_id"
  end

  create_table "decks", force: :cascade do |t|
    t.string "nome"
    t.integer "siorg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logo"
    t.string "sigla"
    t.integer "avaliacoes"
    t.float "aprovacao"
    t.float "media_etapas"
    t.float "digitalizacao"
    t.float "porc_botao_iniciar"
    t.float "media_duracao"
    t.integer "qtd_nao_estimados"
    t.integer "number"
    t.string "identificacao"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "player1"
    t.integer "player2"
    t.integer "winner"
  end

  create_table "hands", force: :cascade do |t|
    t.integer "cardp1"
    t.integer "cardp2"
    t.integer "winner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.index ["game_id"], name: "index_hands_on_game_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "nature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nome"
  end

  create_table "stacks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.bigint "player_id"
    t.text "cards"
    t.index ["game_id"], name: "index_stacks_on_game_id"
    t.index ["player_id"], name: "index_stacks_on_player_id"
  end

end
