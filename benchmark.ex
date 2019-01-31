import Huffman
import FileHandler

defmodule Benchmark do

def bench(text)do
    bench(text, [])
end

def bench(text, res) do
    # encode
    # encode = Huffman.test(text)
    # time = measure(fn -> Huffman.test_encode(text, encode) end) 

    # decode
    seq = Huffman.test_encode(text, Huffman.test(text))
    decode = Huffman.test(text)
    time = measure(fn -> Huffman.test_decode(seq, decode) end)

    if(length(text) > 10) do
        r = [{length(text), time} | res]
        s = elem(split(text),0)
        bench(s, r)
    else
        IO.inspect res
        write(res)  
    end
end

def split(list) do
  len = round(length(list)/2)
  Enum.split(list, len)
end

  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
   # |> Kernel./(1_000_000)
  end
end