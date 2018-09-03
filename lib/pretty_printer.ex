defmodule PrettyPrinter do

	@moduledoc """
		This module is responsible for printing a more beautiful version of the board.
	"""

	@doc """
		Return all cells, each cell is involved by a border
	
	## Parameters

		- board: The current board\n
		- width: Used to split by line\n
		- xray: If true, shows the bombs

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> PrettyPrinter.print_board(2, xray: true)
	"""		
	def print_board(board, width, xray: true) do

		board
			|> get_col_value(xray: true)
			|> Enum.chunk_every(width)
			|> add_border()
	end

	@doc """
		Return all cells, each cell is involved by a border. (Don't show the bombs)
	
	## Parameters

		- board: The current board\n
		- width: Used to split by line

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> PrettyPrinter.print_board(2)
	"""		
	def print_board(board, width, xray \\ false) do

		board
			|> get_col_value()
			|> Enum.chunk_every(width)
			|> add_border()
	end	

	@doc """
		Print all cells, each cell is involved by a border
	
	## Parameters

		- board: The current board\n
		- xray: If true, shows the bombs

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> PrettyPrinter.print(xray: true)
	"""		
	def print(board, xray: true) do

		{width, _} = Board.get_width_height(board)

		board 
			|> print_board(width, xray: true)
			|> print_console(width)
	end

	@doc """
		Print all cells, each cell is involved by a border. (Don't show the bombs)
	
	## Parameters

		- board: The current board\n

	## Examples

		iex(1)> Game.init(2, 2, 1)\n
				|> PrettyPrinter.print()
	"""		
	def print(board, xray \\ false) do
		{width, _} = Board.get_width_height(board)

		board
			|> print_board(width)
			|> print_console(width)
	end

	defp add_border([]) do
		[]
	end

	defp add_border(lines) do

		[head | tail] = lines

		# Example
		# [%{col: 1, value: "."}, %{col: 2, value: "."}]
		# become
		# [
		#	%{col: 2, value: "."}, 
		#	%{col: 4, value: "."}
		# ]
		cells_value = head 
				|> Enum.map(fn item -> %{col: item.col*2, value: item.value} end)

		num_itens = head |> Enum.count

		# Example
		# It will return 
		# [
		#	%{col: 1, value: "|"}, 
		#	%{col: 3, value: "|"}, 
		#	%{col: 5, value: "|"}
		# ]
		border = for n <- 1..(num_itens*2)+1, rem(n, 2) != 0, do: (%{col: n, value: "|"})

		# Join and order
		# Example
		# It will return 
		# [
		#	%{col: 1, value: "|"}, 
		#	%{col: 2, value: "."}, 
		#	%{col: 3, value: "|"}, 
		#	%{col: 4, value: "."},
		#	%{col: 5, value: "|"}
		# ]
		[Enum.sort(cells_value ++ border, &(&1.col < &2.col))] ++ add_border(tail)
	end

	def print_console([], width) do
		IO.puts String.duplicate("-", width*2 + 1)
	end

	def print_console(board, width) do

		IO.puts String.duplicate("-", width*2 + 1)
		[head | tail] = board

		get_value = head |> Enum.map( fn item -> item.value end)

		IO.puts(List.to_string(get_value))
		print_console(tail, width)
	end

	defp get_col_value(board, xray: true) do
		
		board
			|> Enum.map( fn cell -> %{col: cell.col, value: (if cell.bomb, do: BoardFormat.board_format.bomb, else: cell.value)} end)
	end

	defp get_col_value(board) do
		
		board
			|> Enum.map( fn cell -> %{col: cell.col, value: cell.value} end)
	end

end