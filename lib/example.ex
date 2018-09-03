defmodule Example do
  def rand_move(width, height) do
    {:rand.uniform(width), :rand.uniform(height)}
  end

  def print(board) do
    case :rand.uniform > 0.5 do
      :true -> SimplePrinter.print(board)
      :false -> PrettyPrinter.print(board)
    end
  end

  def run(width, height, num_mines) do
    board = Game.init(width, height, num_mines)
    
    # board
    loop(board, width, height)
  end

  def loop(board, width, height) do
    case play(board, width, height) do
      :invalid_move -> 
        IO.puts("Jogada inválida")
        loop(board, width, height)
      :invalid_flag -> 
        IO.puts("Jogada inválida")
        loop(board, width, height)
      :game_over ->
        IO.puts("Você perdeu! As minas eram:")
        PrettyPrinter.print(board, xray: true)
      :victory ->
        IO.puts("Você venceu")
      board -> loop(board, width, height)
    end
  end

  def play(board, width, height) do
    Game.play(board, rand_move(width, height), rand_move(width, height))
  end
end

#Example.run(10, 20, 50)