defmodule Board do

	@moduledoc """
		The board is composed by a rectangular board (width * height) containing\n
		hidden "mines" or bombs that can not be detonated.
	"""

	@doc """
		Return a new bord

	## Parameters

		- width: board width\n
		- height: board height\n
		- mines: list of mines

	## Examples

		iex(1)> Board.new(3, 3, [{1, 1}, {2, 2}])

	"""
	def new(width, height, mines) do

		board = create_board(width, height)
			|> add_bombs(mines)
		
		all_coord = all_coord(board)

		board 
			|> add_number_nearby_bombs(all_coord, mines, width, height)
			|> add_neighbors(all_coord, mines, width, height)

	end

	@doc """

		Returns a board with an updated value at the specified cell.

	## Parameters

		- Cell: The cell that was changed\n
		- board: The current board
	"""
	def update_board(cell, board) do

		board
			|> List.update_at(cell.index - 1, fn cell_found -> cell end)

	end

	@doc """
		Put the flag in the cell.\n

	## Parameters

		- board: The board\n
		- cell: The cell selected

	## Examples

		iex(1)> board = Board.new(3, 3, [{1, 1}, {2, 2}])\n 
		iex(2)> cell = board\n |> Board.find_by_coord({2, 2})\n
		iex(3)> Board.put_flag(cell)\n
	"""		
	def put_flag(board, cell) do

		cell 
			|> Cell.change_attr([{:value, BoardFormat.board_format.flag }])
			|> update_board(board)

	end

	@doc """
		Remove the flag from cell.\n
		* This cell must be previously flagged

	## Parameters

		- board: The board\n
		- cell: The cell selected

	## Examples

		iex(1)> board = Board.new(3, 3, [{1, 1}, {2, 2}])\n 
		iex(2)> cell = board\n |> Board.find_by_coord({2, 2})\n
		iex(3)> board = board\n |> Board.put_flag(cell)\n
		iex(4)> Board.remove_flag(cell)
	"""	
	def remove_flag(board, cell) do

		cell 
			|> Cell.change_attr([{:value, BoardFormat.board_format.unknown_cell}])
			|> update_board(board)

	end

	@doc """
		Return the width and height of board

	## Parameters

		- board: The board

	## Examples

		iex(1)> Board.new(3, 3, [{1, 1}, {2, 2}])\n 
					|> Board.get_width_height()
	"""
	def get_width_height(board) do

		last_cell = board |> List.last 
		{last_cell.col, last_cell.row}

	end
	
	@doc """
		Returns true if the current cell has a flag

	## Parameters

		- Cell: A specific cell of board

	## Examples

		iex(1)> Board.new(3, 3, [{1, 1}, {2, 2}])\n
					|> Board.find_by_coord({2, 2})\n
						|> Board.flag?
	"""	
	def flag?(cell) do

		cell.value == BoardFormat.board_format.flag

	end

	@doc """
		Returns true if the current cell is clean

	## Parameters

		- Cell: A specific cell of board

	## Examples

		iex(1)> Board.new(3, 3, [{1, 1}, {2, 2}])\n
					|> Board.find_by_coord({2, 2})\n
						|> Board.clear_cell?
	"""
	def clear_cell?(cell) do

		cell.value == BoardFormat.board_format.clear_cell

	end

	@doc """
		Returns true if the current cell has a bomb

	## Parameters

		- Cell: A specific cell of board

	## Examples

		iex(1)> Board.new(3, 3, [{1, 1}, {2, 2}])\n
					|> Board.find_by_coord({2, 2})\n
						|> Board.bomb?
	"""			
	def bomb?(cell) do

		cell.bomb

	end

	@doc """
		Find the cell by coordinates

	## Parameters

		- board: The board\n
		- {coord_x, coord_y}: The cell coordinates

	## Examples

		iex(1)> Board.new(3, 3, [{1, 1}, {2, 2}])\n
					|> Board.find_by_coord({1, 1}
	"""
	def find_by_coord(board, {coord_x, coord_y}) do
		
		board 
			|> Enum.find( fn cell -> cell.row == coord_y && cell.col == coord_x end)

	end

	@doc """
		Returns true if the all unknown cells are discovered

	## Parameters

		- board: The board

	## Examples

		iex(1)> Board.victory?(board)
	"""
	def victory?(board) do
		
		board 
			|> Enum.filter( fn cell -> cell.bomb == :false end)
			|> Enum.filter( fn cell -> cell.value == BoardFormat.board_format.unknown_cell || cell.value == BoardFormat.board_format.flag end )
			|> Enum.empty?

	end	

	#Private methods #########################################

	defp create_board(width, height) do

		cells = for row <-(1..height),
					col <-(1..width), 
						do: Cell.new(col, row, create_index(col, row, width))

		cells |> List.flatten()

	end

	defp add_bombs(board, []) do

		board

	end

	defp add_bombs(board, mines) do
		
		[head | tail] = mines

		board = board 
				|> find_by_coord(head)
				|> Cell.change_attr([{:bomb, :true}])
				|> update_board(board)

		add_bombs(board, tail)

	end	

	defp all_coord(board) do

		board 
			|> Enum.map( fn cell -> {cell.col, cell.row} end)

	end

	defp create_index(col, row, width) do

		(row - 1) * width + col

	end

	defp add_number_nearby_bombs(board, [], mines, width, height) do

		board

	end

	defp add_number_nearby_bombs(board, coords, mines, width, height) do

		[head | tail] = coords

		{coord_x, coord_y} = head

		number_nearby_bombs = risk_zone(mines, width, height)
								|> Enum.filter(fn {x, y} -> x == coord_x && y == coord_y end) 
									|> Enum.count

		unless number_nearby_bombs == 0 do

			board = board 
						|> find_by_coord({coord_x, coord_y})
						|> Cell.change_attr([{:number_neighbors, number_nearby_bombs}])
						|> update_board(board)
			
			add_number_nearby_bombs(board, tail, mines, width, height)
		else

			add_number_nearby_bombs(board, tail, mines, width, height)
		end

	end	

	defp add_neighbors(board, [], mines, width, height) do

		board

	end

	defp add_neighbors(board, coords, mines, width, height) do

		[head | tail] = coords

		{coord_x, coord_y} = head

		cell = board |> find_by_coord({coord_x, coord_y})

		if cell.number_neighbors == 0 do

			neighbors = coord_neighbors(coord_x, coord_y, width, height)

			board = Cell.change_attr(cell, [{:neighbors, neighbors}])
					|> update_board(board)

			add_neighbors(board, tail, mines, width, height)

		else

			add_neighbors(board, tail, mines, width, height)
		end

	end

	defp risk_zone([], limit_width, limit_height) do

		[]

	end

	defp risk_zone(mines, limit_width, limit_height) do

		[head | tail] = mines

		{coord_x, coord_y} = head

		list = for col <- coord_x-1..coord_x+1,
				row <- coord_y-1..coord_y+1, do: {col, row}

		list = list |> Enum.filter(fn coord -> valid_coords?(coord ,{limit_width, limit_height}) end)

		list = list ++ risk_zone(tail, limit_width, limit_height)

	end

	defp coord_neighbors(coord_x, coord_y, limit_width, limit_height) do

		list = for col <- coord_x-1..coord_x+1,
					row <- coord_y-1..coord_y+1, do: {col, row}

		#Remove yourself
		list = list -- [{coord_x, coord_y}]

		list 
			|> Enum.filter(fn coord -> valid_coords?(coord ,{limit_width, limit_height}) end)

	end	

	defp valid_coords?({coord_x, coord_y}, {limit_width, limit_height}) do

		coord_x > 0 && coord_x <= limit_width 
			&& coord_y > 0 && coord_y <= limit_height

	end

end
