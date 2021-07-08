# frozen_string_literal: true

require 'stockfish'

RSpec.describe Stockfish do
  it do
    app = Stockfish.start(path: "/usr/local/bin/stockfish")

    app.

  end
end

# require 'open3'

#

# def readline(io)
#   line = io.readline
#   print "line: #{line}"
#   line
# end

# io = IO.popen(engine_path, "r+")

# io.puts "uci"

# loop do
#   line = readline(io)
#   break if line =~ /^uciok/
# end

# puts "end"
