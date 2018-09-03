defmodule SimplePrinter do

	@moduledoc """
		This module is responsible for printing a simple board.
	"""

	@doc """
		Return all cells
	
	## Parameters

		- board: The current board\n
		- width: Used to split by line\n
		- xray: If true, shows the bombs

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> SimplePrinter.print_board(2, xray: true)
	"""
	def print_board(board, width, xray: true) do

		board
			|> get_col_value(xray: true)
				|> Enum.chunk_every(width)
	end

	@doc """
		Return all cells. (Don't show the bombs)
	
	## Parameters

		- board: The current board\n
		- width: Used to split by line

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> SimplePrinter.print_board(2)
	"""	
	def print_board(board, width, xray \\ false) do

		board
			|> get_col_value()
				|> Enum.chunk_every(width)
	end	

	@doc """
		Print all cells.
	
	## Parameters

		- board: The current board\n
		- xray: If true, shows the bombs

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> SimplePrinter.print(2)
	"""
	def print(board, xray: true) do

		{width, _} = Board.get_width_height(board)

		board 
			|> print_board(width, xray: true)
				|> print_console(width)
	end

	@doc """
		Print all cells. (Don't show the bombs)
	
	## Parameters

		- board: The current board

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> SimplePrinter.print(2)
	"""
	def print(board, xray \\ false) do
		{width, _} = Board.get_width_height(board)

		board
			|> print_board(width)
				|> print_console(width)
	end

	def print_console([], width) do
		IO.puts ""
	end

	def print_console(board, width) do

		[head | tail] = board

		get_value = head |> Enum.map( fn item -> item.value end)

		IO.puts(List.to_string(get_value))
		print_console(tail, width)
	end

	defp get_col_value(board, xray: true) do
		
		board
			|> Enum.map( fn cell -> %{col: cell.col, value: (if cell.bomb, do: "[#]", else: "[#{cell.value}]")} end)
	end

	defp get_col_value(board) do
		
		board
			|> Enum.map( fn cell -> %{col: cell.col, value: "[#{cell.value}]"} end)
	end
end