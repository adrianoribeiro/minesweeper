defmodule Game do

	@moduledoc """
		This module is responsible to handle the board.
	"""

	@doc """
		Return a new game\n
		A board is return according params
	
	## Parameters

		- width: board width\n
		- height: board height\n
		- mines: list of mines

	## Examples

		iex(1)> Game.init(2, 1, 1) \n
					|> Game.play({2, 1}, {2, 1})
	"""	
	def init(width, height, num_bombs) do

		generate_bombs = generate_bombs(width, height, num_bombs)

		Board.new(width, height, generate_bombs)

	end

	@doc """
	Make a movie, there are two possibilities\n
		1) Click the cell\n
			1.1) If this cells is :unknown_cell, it must become :clear_cell\n
			1.2) If this cells is :clear_cell, return :invalid_move\n
			1.3) If this cells is :bomb, return :game_over\n\n
		2) Click the cell to put a flag\n
			2.1) If this cells is :flag, it must become :unknown_cell\n
			2.2) If this cells is :unknown_cell or :bomb, it must become :flag\n
			2.3) If this cells is :clear_cell, return :invalid_move\n\n

		There is a random event that decides witch possibility will be chosen\n
	
	## Parameters

		- board: The board \n
		- play_coordinates: Play coordinates\n
		- flag_coordinates: Flag coordinates

	## Examples

		iex(1)> Game.init(2, 1, 1) \n
					|> Game.play({2, 1}, {2, 1})

	"""
	def play(board, play_coordinates, flag_coordinates) do

		case :rand.uniform > 0.5 do
			:true -> 
				{coord_x, coord_y} = play_coordinates
				click(board, {coord_x, coord_y})
			:false -> 
				{coord_x, coord_y} = flag_coordinates
				flag(board, {coord_x, coord_y})
		end

	end

	@doc """
	Make a movie, there are two possibilities\n
		1) Click the cell\n
			1.1) If this cells is :unknown_cell, it must become :clear_cell\n
			1.2) If this cells is :clear_cell, return :invalid_move\n
			1.3) If this cells is :bomb, return :game_over\n\n
		2) Click the cell to put a flag\n
			2.1) If this cells is :flag, it must become :unknown_cell\n
			2.2) If this cells is :unknown_cell or :bomb, it must become :flag\n
			2.3) If this cells is :clear_cell, return :invalid_move\n\n

		There is a random event that decides witch possibility will be chosen\n
	
	## Parameters

		- board: The board \n
		- coordinates: Play/Flag coordinates

	## Examples

		iex(1)> Game.init(2, 1, 1) \n
					|> Game.play({2, 1})
	"""	
	def play(board, coordinates) do

		case :rand.uniform > 0.5 do
			:true -> 
				{coord_x, coord_y} = coordinates
				click(board, {coord_x, coord_y})
			:false -> 
				{coord_x, coord_y} = coordinates
				flag(board, {coord_x, coord_y})
		end

	end

	@doc """
	Make a movie\n
		1) Click the cell\n
			1.1) If this cells is :unknown_cell, it must become :clear_cell\n
			1.2) If this cells is :clear_cell, return :invalid_move\n
			1.3) If this cells is :bomb, return :game_over\n\n
	
	## Parameters

		- board: The board \n
		- play_coordinates: Play coordinates

	## Examples

		iex(1)> Game.init(2, 1, 1)\n
				|> Game.flag({1,1}) 
	"""
	def click(board, {coord_x, coord_y}) do

		last_cell = board |> List.last

		limite = {last_cell.col, last_cell.row}

		cell = Board.find_by_coord(board, {coord_x, coord_y})

		result = 
			case Board.bomb?(cell) do
				:true -> :game_over
				:false -> 
					cond do
						BoardFormat.board_format.unknown_cell == cell.value -> discover(board, coord_x, coord_y, limite)
						BoardFormat.board_format.clear_cell == cell.value -> :invalid_move
						BoardFormat.board_format.flag	== cell.value -> :invalid_move
					end
			end

		result

	end

	@doc """
	Put a flag\n
		1) Click the cell to put a flag\n
			1.1) If this cells is :flag, it must become :unknown_cell\n
			1.2) If this cells is :unknown_cell or :bomb, it must become :flag\n
			1.3) If this cells is :clear_cell, return :invalid_move\n\n
	
	## Parameters

		- board: The board \n
		- flag_coordinates: Flag coordinates

	## Examples

		iex(1)> Game.init(2, 1, 1) \n
					|> Game.play({2, 1}, {2, 1})

	"""
	def flag(board, {coord_x, coord_y}) do

		cell = Board.find_by_coord(board, {coord_x, coord_y})

		retorno = 
			case Board.clear_cell?(cell) do
				:true -> :invalid_flag
				:false -> 
						case Board.flag?(cell) do
							:true -> board |> Board.remove_flag(cell)
							:false -> board |> Board.put_flag(cell)
						end
			end

		retorno

	end

	#Private methods #########################################
	
	defp generate_bombs(width, height, num_bombs) do

		list = for x <- 1..width,
			y <- 1..height, do: {x,y}

		list |> Enum.take_random(num_bombs) 
	end

	defp discover(board, coord_x, coord_y, limite) do

		cell = Board.find_by_coord(board, {coord_x, coord_y})

		#Get neighbors before to empty it
		neighbors = cell.neighbors

		cell = cell |> Cell.change_attr([{:value, BoardFormat.board_format.clear_cell}, {:neighbors, []}])

		board = cell |> Board.update_board(board)

		board = 
			unless neighbors == [] do

				discover_neighbors(board, neighbors)
			else

				board
			end

			case Board.victory?(board) do
				:true -> :victory
				:false -> board
			end

	end

	defp discover_neighbors(board, []) do

		board
	end

	defp discover_neighbors(board, coords_neighbors) do

		[head | tail] = coords_neighbors

		{coord_x, coord_y} = head

		cell = Board.find_by_coord(board, {coord_x, coord_y})

		#Get neighbors before to empty it
		neighbors = cell.neighbors

		board = cell 
			|> Cell.change_attr([{:value, BoardFormat.board_format.clear_cell}, {:neighbors, []}])
			|> Board.update_board(board)

		board = discover_neighbors(board, neighbors)	

		board = discover_neighbors(board, tail)

		board

	end

	defp coords_neighbors(coord_x, coord_y, limit) do

		list = for x <- coord_x-1..coord_x+1,
					y <- coord_y-1..coord_y+1, do: {x, y}

		list 
			|> Enum.filter(fn({x,y}) -> x>=1 && y>=1 end)
			|> Enum.filter(fn({x,y}) -> x<=limit && y<=limit end)

	end

end
