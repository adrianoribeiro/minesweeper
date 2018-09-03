defmodule PrettyPrinterTest do
 	use ExUnit.Case

	@moduletag :pretty_printer

	test "pretty printer" do

		{width, height, mines} = {3, 2, [{2, 2}]}

		result = Board.new(width, height, mines) 
				 |> PrettyPrinter.print_board(width)
	
		expected_result = [
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.unknown_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.unknown_cell},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"}
			],
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.unknown_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.unknown_cell},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"}
			]
		]
		
		assert expected_result  == result

	end
	
	test "pretty printer with xray" do

		{width, height, mines} = {3, 2, [{2, 2}]}

		result = Board.new(width, height, mines) 
					|> PrettyPrinter.print_board(width, xray: true)
	
		expected_result = [
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.unknown_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.unknown_cell},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"}
			],
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.unknown_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.bomb},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"}
			]
		]
		
		assert expected_result == result

	end

	test "pretty printer with xray and flag" do

		{width, height, mines} = {5, 4, [{1, 2}, {2, 1}, {5, 4}]}

		board = Board.new(width, height, mines) 
		board = Game.click(board, {1, 1})
		board = Game.flag(board, {4, 1})

		result = board |> PrettyPrinter.print_board(width, xray: true)
	
		# -----------
		# | |#|.|F|.|
		# -----------
		# |#|.|.|.|.|
		# -----------
		# |.|.|.|.|.|
		# -----------
		# |.|.|.|.|#|
		# -----------

		expected_result = [
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.clear_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.bomb},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"},
				%{col: 8, value: BoardFormat.board_format.flag},
				%{col: 9, value: "|"},
				%{col: 10, value: BoardFormat.board_format.unknown_cell},
				%{col: 11, value: "|"}
			],
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.bomb},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.unknown_cell},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"},
				%{col: 8, value: BoardFormat.board_format.unknown_cell},
				%{col: 9, value: "|"},
				%{col: 10, value: BoardFormat.board_format.unknown_cell},
				%{col: 11, value: "|"}
			],
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.unknown_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.unknown_cell},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"},
				%{col: 8, value: BoardFormat.board_format.unknown_cell},
				%{col: 9, value: "|"},
				%{col: 10, value: BoardFormat.board_format.unknown_cell},
				%{col: 11, value: "|"}
			],
			[
				%{col: 1, value: "|"},
				%{col: 2, value: BoardFormat.board_format.unknown_cell},
				%{col: 3, value: "|"},
				%{col: 4, value: BoardFormat.board_format.unknown_cell},
				%{col: 5, value: "|"},
				%{col: 6, value: BoardFormat.board_format.unknown_cell},
				%{col: 7, value: "|"},
				%{col: 8, value: BoardFormat.board_format.unknown_cell},
				%{col: 9, value: "|"},
				%{col: 10, value: BoardFormat.board_format.bomb},
				%{col: 11, value: "|"}
			]
		]
		
		assert expected_result  == result
	end

end
