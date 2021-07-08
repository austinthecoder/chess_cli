require "ivo"

module Stockfish
  extend self

  Interface = Ivo.new

  def start(path:)
    Interface.new
  end
end
