defmodule BoardTest do
	use ExUnit.Case

	@moduletag :board

	test "verify number of cells" do

		{width, height, mines} = {5, 4, [{1, 1}, {1, 2}]}

		num_cells_generated = 
			Board.new(width, height, mines) 
				|> Enum.filter(fn cell -> cell.value == BoardFormat.board_format.unknown_cell end )
					|> Enum.count

		assert num_cells_generated == width*height

	end

	test "number of bombs" do

		{width, height, mines} = {5, 4, [{1, 1}, {1, 2}]}

		board = Board.new(width, height, mines)
		num_mines_generated = board 
			|> Enum.filter(fn cell -> cell.bomb end )
				|> Enum.count

		assert num_mines_generated == 2

	end

	test "number of unknown cell" do

		{width, height, mines} = {5, 4, [{1, 1}, {1, 2}, {2,3}]}

		board = Board.new(width, height, mines)
		num_unknown_cell_generated = board 
			|> Enum.filter(fn cell -> !cell.bomb end )
				|> Enum.count

		assert num_unknown_cell_generated == width * height - 3

	end

	test "add number nearby bombs" do

		{width, height, mines} = {5, 4, [{2, 2}, {4, 3}]}

		board = Board.new(width, height, mines) 

		cell_1 = board |> Board.find_by_coord({1, 1})
		assert cell_1.number_neighbors == 1

		cell_2 = board |> Board.find_by_coord({1, 2})
		assert cell_2.number_neighbors == 1

		cell_3 = board |> Board.find_by_coord({1, 4})
		assert cell_3.number_neighbors == 0

		cell_4 = board |> Board.find_by_coord({2, 2})
		assert cell_4.number_neighbors == 1

		cell_5 = board |> Board.find_by_coord({3, 2})
		assert cell_5.number_neighbors == 2

		cell_6 = board |> Board.find_by_coord({1, 4})
		assert cell_6.number_neighbors == 0

	end

	test "add neighbors" do

		{width, height, mines} = {5, 4, [{2, 2}, {4, 3}]}

		board = Board.new(width, height, mines) 
		cell_1 = board |> Board.find_by_coord({1, 1})
		assert cell_1.neighbors == []
		cell_2 = board |> Board.find_by_coord({4, 1})
		cell_2_neighbors_order = cell_2.neighbors  |> Enum.sort

		assert cell_2_neighbors_order == [{3, 1}, {3, 2}, {4, 2}, {5, 1}, {5, 2}]

	end

	test "get width height" do

		assert {3, 3} == Board.new(3, 3, [{1, 1}, {2, 2}])
							|> Board.get_width_height()

	end

	test "find by coord" do

		{width, height, mines} = {5, 4, [{1, 1}, {1, 2}]}
		board = Board.new(width, height, mines)
		cell = board |> Board.find_by_coord({1, 2}) 
		assert :true == cell.bomb
		
	end

end
