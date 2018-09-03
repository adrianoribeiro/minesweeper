defmodule SimplePrinterTest do
	use ExUnit.Case

	@moduletag :simple_printer

	test "simple printer" do

		{width, height, mines} = {3, 2, [{2, 2}]}

		result = Board.new(width, height, mines) 
					|> SimplePrinter.print_board(width)
	
		expected_result = [
			[
				%{col: 1, value: "[.]"},
				%{col: 2, value: "[.]"},
				%{col: 3, value: "[.]"}
			],
			[
				%{col: 1, value: "[.]"},
				%{col: 2, value: "[.]"},
				%{col: 3, value: "[.]"}
			]
		]
		
		assert expected_result  == result
	end
	
	
	test "simple printer with xray" do

		{width, height, mines} = {3, 2, [{2, 2}]}

		result = Board.new(width, height, mines) 
					|> SimplePrinter.print_board(width, xray: true)
	
		expected_result = [
			[
				%{col: 1, value: "[.]"},
				%{col: 2, value: "[.]"},
				%{col: 3, value: "[.]"}
			],
			[
				%{col: 1, value: "[.]"},
				%{col: 2, value: "[#]"},
				%{col: 3, value: "[.]"}
			]
		]
		
		assert expected_result  == result

	end

	test "simple printer with xray and flag" do

		{width, height, mines} = {5, 4, [{1, 2}, {2, 1}, {5, 4}]}

		board = Board.new(width, height, mines) 
		board = Game.click(board, {1, 1})
		board = Game.flag(board, {4, 1})

		result = board
				|> SimplePrinter.print_board(width, xray: true)
	
		# [ ][#][.][F][.]
		# [#][.][.][.][.]
		# [.][.][.][.][.]
		# [.][.][.][.][#]

		expected_result = [
			[
			  %{col: 1, value: "[ ]"},
			  %{col: 2, value: "[#]"},
			  %{col: 3, value: "[.]"},
			  %{col: 4, value: "[F]"},
			  %{col: 5, value: "[.]"}
			],
			[
			  %{col: 1, value: "[#]"},
			  %{col: 2, value: "[.]"},
			  %{col: 3, value: "[.]"},
			  %{col: 4, value: "[.]"},
			  %{col: 5, value: "[.]"}
			],
			[
			  %{col: 1, value: "[.]"},
			  %{col: 2, value: "[.]"},
			  %{col: 3, value: "[.]"},
			  %{col: 4, value: "[.]"},
			  %{col: 5, value: "[.]"}
			],
			[
			  %{col: 1, value: "[.]"},
			  %{col: 2, value: "[.]"},
			  %{col: 3, value: "[.]"},
			  %{col: 4, value: "[.]"},
			  %{col: 5, value: "[#]"}
			]
		  ]
		
		assert expected_result  == result
	end

end
