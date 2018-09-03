defmodule Cell do
    defstruct row: 0, col: 0, value: BoardFormat.board_format.unknown_cell, bomb: :false, number_neighbors: 0, neighbors: [], index: 0

    def new(col, row, index) do
    	%Cell{row: row, col: col, value: BoardFormat.board_format.unknown_cell, bomb: :false, number_neighbors: 0, neighbors: [], index: index}
    end

    def change_attr(cell, []) do

    	cell
    end

    def change_attr(cell, attr_value_list) do
    	
		[head | tail] = attr_value_list

		{attr, value} = head

		%{cell | attr => value}
			|> change_attr(tail)
    end

end