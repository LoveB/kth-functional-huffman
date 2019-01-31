defmodule FileHandler do

     def read(file, n) do
        {:ok, file} = File.open(file, [:read])
        binary = IO.read(file, n)
        File.close(file)
            case :unicode.characters_to_list(binary, :utf8) do
                {:incomplete, list, _} ->
                list; list ->
                list
            end 
    end

    def write(res) do
        #Open the file in read, write and utf8 modes. 
        file_x = File.open!("x", [:read, :utf8, :write])
        file_y = File.open!("y", [:read, :utf8, :write])

        #Write to this "io_device" using standard IO functions
        for {x, y} <- res, do: IO.puts(file_x, x)
        for {x, y} <- res, do: IO.puts(file_y, y)

        File.close(file_x)
        File.close(file_y)

    end
end
