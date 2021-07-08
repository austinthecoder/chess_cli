# frozen_string_literal: true

require 'securerandom'
require "ivo"
require_relative "chess_cli/version"

module ChessCli
  class Error < StandardError; end

  PIECE_CHARACTER_BY_TYPE_BY_COLOR = {
    white: {
      rook: "♜",
      knight: "♞",
      bishop: "♝",
      queen: "♛",
      king: "♚",
      pawn: "♟",
    },
    black: {
      rook: "♖",
      knight: "♘",
      bishop: "♗",
      queen: "♕",
      king: "♔",
      pawn: "♙",
    },
  }.freeze

  BOARD_TEMPLATE_BY_COLOR = {
    white: <<~TEXT,
        +---+---+---+---+---+---+---+---+
      8 | %{a8} | %{b8} | %{c8} | %{d8} | %{e8} | %{f8} | %{g8} | %{h8} |
        |---+---+---+---+---+---+---+---|
      7 | %{a7} | %{b7} | %{c7} | %{d7} | %{e7} | %{f7} | %{g7} | %{h7} |
        |---+---+---+---+---+---+---+---|
      6 | %{a6} | %{b6} | %{c6} | %{d6} | %{e6} | %{f6} | %{g6} | %{h6} |
        |---+---+---+---+---+---+---+---|
      5 | %{a5} | %{b5} | %{c5} | %{d5} | %{e5} | %{f5} | %{g5} | %{h5} |
        |---+---+---+---+---+---+---+---|
      4 | %{a4} | %{b4} | %{c4} | %{d4} | %{e4} | %{f4} | %{g4} | %{h4} |
        |---+---+---+---+---+---+---+---|
      3 | %{a3} | %{b3} | %{c3} | %{d3} | %{e3} | %{f3} | %{g3} | %{h3} |
        |---+---+---+---+---+---+---+---|
      2 | %{a2} | %{b2} | %{c2} | %{d2} | %{e2} | %{f2} | %{g2} | %{h2} |
        |---+---+---+---+---+---+---+---|
      1 | %{a1} | %{b1} | %{c1} | %{d1} | %{e1} | %{f1} | %{g1} | %{h1} |
        +---+---+---+---+---+---+---+---+
          a   b   c   d   e   f   g   h
    TEXT
    black: <<~TEXT,
        +---+---+---+---+---+---+---+---+
      1 | %{h1} | %{g1} | %{f1} | %{e1} | %{d1} | %{c1} | %{b1} | %{a1} |
        |---+---+---+---+---+---+---+---|
      2 | %{h2} | %{g2} | %{f2} | %{e2} | %{d2} | %{c2} | %{b2} | %{a2} |
        |---+---+---+---+---+---+---+---|
      3 | %{h3} | %{g3} | %{f3} | %{e3} | %{d3} | %{c3} | %{b3} | %{a3} |
        |---+---+---+---+---+---+---+---|
      4 | %{h4} | %{g4} | %{f4} | %{e4} | %{d4} | %{c4} | %{b4} | %{a4} |
        |---+---+---+---+---+---+---+---|
      5 | %{h5} | %{g5} | %{f5} | %{e5} | %{d5} | %{c5} | %{b5} | %{a5} |
        |---+---+---+---+---+---+---+---|
      6 | %{h6} | %{g6} | %{f6} | %{e6} | %{d6} | %{c6} | %{b6} | %{a6} |
        |---+---+---+---+---+---+---+---|
      7 | %{h7} | %{g7} | %{f7} | %{e7} | %{d7} | %{c7} | %{b7} | %{a7} |
        |---+---+---+---+---+---+---+---|
      8 | %{h8} | %{g8} | %{f8} | %{e8} | %{d8} | %{c8} | %{b8} | %{a8} |
        +---+---+---+---+---+---+---+---+
          h   g   f   e   d   c   b   a
    TEXT
  }

  extend self

  Interface = Ivo.new(:game_by_id) do
    def start_game
      game_id = SecureRandom.uuid
      piece_by_square = {
        a1: Piece.new(:white, :rook),
        b1: Piece.new(:white, :knight),
        c1: Piece.new(:white, :bishop),
        d1: Piece.new(:white, :queen),
        e1: Piece.new(:white, :king),
        f1: Piece.new(:white, :bishop),
        g1: Piece.new(:white, :knight),
        h1: Piece.new(:white, :rook),

        a2: Piece.new(:white, :pawn),
        b2: Piece.new(:white, :pawn),
        c2: Piece.new(:white, :pawn),
        d2: Piece.new(:white, :pawn),
        e2: Piece.new(:white, :pawn),
        f2: Piece.new(:white, :pawn),
        g2: Piece.new(:white, :pawn),
        h2: Piece.new(:white, :pawn),

        a7: Piece.new(:black, :pawn),
        b7: Piece.new(:black, :pawn),
        c7: Piece.new(:black, :pawn),
        d7: Piece.new(:black, :pawn),
        e7: Piece.new(:black, :pawn),
        f7: Piece.new(:black, :pawn),
        g7: Piece.new(:black, :pawn),
        h7: Piece.new(:black, :pawn),

        a8: Piece.new(:black, :rook),
        b8: Piece.new(:black, :knight),
        c8: Piece.new(:black, :bishop),
        d8: Piece.new(:black, :queen),
        e8: Piece.new(:black, :king),
        f8: Piece.new(:black, :bishop),
        g8: Piece.new(:black, :knight),
        h8: Piece.new(:black, :rook),
      }
      game = Game.new(game_id, piece_by_square)
      save_game(game)
      game_id
    end

    def print_game(game_id, color)
      game = game_by_id[game_id]

      subs = game.piece_by_square.transform_values(&:to_s)
      subs.default = " "

      BOARD_TEMPLATE_BY_COLOR[color] % subs
    end

    def move_piece(game_id, from_square, to_square)
      game = game_by_id[game_id]
      from_piece = game.piece_by_square[from_square]
      to_piece = game.piece_by_square[to_square]

      new_piece_by_square = game.piece_by_square
        .reject { |square, _| square == from_square }
        .merge(to_square => from_piece)

      game = Game.new(game_id, new_piece_by_square)

      save_game(game)
    end

    private

    def save_game(game)
      game_by_id.merge!(game.id => game)
      :ok
    end
  end

  Game = Ivo.new(:id, :piece_by_square)

  Piece = Ivo.new(:color, :type) do
    def to_s
      PIECE_CHARACTER_BY_TYPE_BY_COLOR[color][type]
    end
  end

  def start
    Interface.new({})
  end
end
