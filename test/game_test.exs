defmodule GameTest do
	use ExUnit.Case

	@moduletag :game

	test "click on bomb" do

		{width, height, mines} = {5, 4, [{2, 2}, {4, 3}]}
		board = Board.new(width, height, mines)
		assert :game_over == Game.click(board, {4, 3}) 

	end

	test "click on unknown cell ignoring neighbors" do

		{width, height, mines} = {5, 4, [{2, 2}, {4, 3}]}
		cell = Board.new(width, height, mines)
				|> Game.click({1, 1}) 
					|> Board.find_by_coord({1, 1})
		assert cell.value == BoardFormat.board_format.clear_cell

	end

	test "open unknown cell and yours neighbors" do

		{width, height, mines} = {5, 4, [{2, 2}, {4, 3}]}

		board = Board.new(width, height, mines)
		board = Game.click(board, {4, 1}) 

		clean_cells = board 
			|> Enum.filter( fn cell -> cell.value == BoardFormat.board_format.clear_cell end) 
				|> Enum.map(fn cell -> {cell.col, cell.row} end) 
					|> Enum.sort 

		assert clean_cells == [{3, 1}, {3, 2}, {4, 1}, {4, 2}, {5, 1}, {5, 2}] 

	end

	test "open unknown cell with neighbor bomb" do

		{width, height, mines} = {4, 3, [{2, 1}, {1, 2}]}

		board = Board.new(width, height, mines)
		board = Game.click(board, {3, 1})

		clean_cells = board 
			|> Enum.filter( fn cell -> cell.value == BoardFormat.board_format.clear_cell end) 
				|> Enum.map(fn cell -> {cell.col, cell.row} end) 
					|> Enum.sort 

		assert clean_cells == [{3, 1}] 

	end

	test "open unknown cell and yours neighbors (more deep)" do

		{width, height, mines} = {4, 4, [{1, 2}, {2, 1}]}

		#Initialize board
		board = Board.new(width, height, mines)

		#Get all cells
		all_cells = board 
			|> Enum.filter( fn cell -> cell.value == BoardFormat.board_format.unknown_cell end) 
				|> Enum.map(fn cell -> {cell.col, cell.row} end) 

		#Click
		board = Game.click(board, {4, 1})

		#Get all clean cells
		clean_cells = board 
			|> Enum.filter( fn cell -> cell.value == BoardFormat.board_format.clear_cell end) 
				|> Enum.map(fn cell -> {cell.col, cell.row} end) 

		#Get the diff
		result_cells = 
				all_cells -- clean_cells 
					|> Enum.sort

		assert result_cells == [{1, 1}, {1, 2}, {2, 1}]
	end

	test "put and remove flag in an unknown cell is ok" do

		{width, height, mines} = {4, 3, [{1, 2}, {2, 1}]}

		board = Board.new(width, height, mines)
		cell = board |> Board.find_by_coord({1, 1})

		#The flag isn't put yet
		assert :false == Board.flag?(cell)
		board = Board.new(width, height, mines)
					|> Game.flag({1, 1})

		cell = board |> Board.find_by_coord({1, 1})
		assert :true == Board.flag?(cell)

		#Remove flag
		board = board |> Game.flag({1, 1})
		cell = board |> Board.find_by_coord({1, 1})

		assert :false == Board.flag?(cell)
	end

	test "try put flag in an clear cell" do

		{width, height, mines} = {4, 3, [{1, 2}, {2, 1}]}
		board = Board.new(width, height, mines)
		board = board |> Game.click({1,1})
		cell = board |> Board.find_by_coord({1, 1})

		#Now the cell is clean
		assert :true == Board.clear_cell?(cell)
		assert :invalid_flag == Game.flag(board, {1,1})
	end

	test "not victory" do

		{width, height, mines} = {4, 4, [{1, 2}, {2, 1}]}
		board = Board.new(width, height, mines)
		refute :victory == Game.click(board, {1, 1})

	end

	test "victory" do

		{width, height, mines} = {4, 4, [{1, 2}, {2, 1}]}
		board = Board.new(width, height, mines)
		board = Game.click(board, {4, 1})
		assert :victory == Game.click(board, {1, 1})

	end

	test "another victory" do

		{width, height, mines} = {5, 5, [{5, 5}]}
		board = Board.new(width, height, mines)
		assert :victory == Game.click(board, {2, 2})

	end

end
