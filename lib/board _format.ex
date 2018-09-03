defmodule BoardFormat do
    
    def board_format do
        %{
            unknown_cell: ".",
            clear_cell: " " ,
            bomb: "#",
            flag: "F"
          }    
    end
end