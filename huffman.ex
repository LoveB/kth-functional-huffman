import FileHandler


defmodule Huffman do

    def sample do
    sample = elem(File.read("large_sample.txt"),1)
    char_list_sample = to_char_list(sample)
    end

    def text()  do
    # text = elem(File.read("text.txt"),1)
    # char_list_text = to_char_list(text)  

   'en lite mindre text att koda'  
    
    end

    def test(text) do
        sample = sample()
        tree = tree(sample)
        encode = encode_table(tree)
        #decode = decode_table(tree)
        #seq = encode(text, encode)
        #decode(seq, decode)
    end

    def test_encode(text, encode) do
        seq = encode(text, encode)
    end

    def test_decode(seq, decode)do
        decode(seq, decode)
    end

    def tree(sample) do
        freq = freq(sample) 
        huffman(freq)
    end

    # calculating frequencies
    #
    def freq(sample) do 
        freq(sample, [])
    end
    def freq([], freq) do 
        freq
    end
    def freq([char | rest], freq) do
        freq(rest, update(char, freq))
    end

    def update(char, []) do 
        [{char, 1}]
    end
    def update(char, [{char, n} | freq]) do
        [{char, n + 1} | freq]
    end
    def update(char, [h | t]) do
        [h | update(char, t)]
    end

    # Building tree
    def huffman([]) do
        [] 
    end
    def huffman(freq) do
        huffman(freq, []) 
    end
    def huffman([], [freq|rest]) do
        [tree|total_freq] = Tuple.to_list(freq)
        tree
    end
    def huffman(freq, rest) do
        new_freq = freq ++ rest
        [h1|t1] = smallest(new_freq)  #Find the smallest of the original and combined freq
        [h2|t2] = smallest(t1)        #Find the second smallest 
        huffman(t2, add(h1, [h2]))    #run recursively with the smallest nodes combined as rest
    end

    def smallest([h| []], bigger) do
        [h|bigger]
    end
    def smallest(freq) do
        smallest(freq, [])
    end
    def smallest([{c1, f1} | [{c2, f2} | t]], bigger) do
        if (f1 <= f2) do                                    # if freq f1 <= f2, move f2 to the list of bigger freq
            add_big = bigger ++ [{c2, f2}]                  # move on and compare to the whole list recurs
            smallest([{c1, f1} | t], add_big )
        else
            add_big = bigger ++ [{c1, f1}]                  # if smaller, move f1 to bigger list
            smallest([{c2, f2} | t], add_big)
        end
    end

    def add({char, freq}, []) do
        [{char, freq}]
    end
    def add({c1, f1}, [{c2, f2}]) do                        #Combine nodes and add their freq
        [{{c1, c2}, f1 + f2}]
    end

    # Building encoding table
    def encode_table([]) do
        []
    end
    def encode_table(tree) do
        encode_table(tree, [], [])
    end

    def encode_table(tree, list, nr) do
        list = list ++ [nr]
        if (is_integer(tree)) do                # if you reach a leaf in the tree     
            list_mod = List.delete_at(list, 0)  # delete first element in list
            encode_map(tree, list_mod)          # map the charachter    
        else
            map1 = encode_table(elem(tree, 0), list, 0) # Go left
            map2 = encode_table(elem(tree, 1), list, 1) # Go right
            final_map = Map.merge(map1, map2)           # merge
        end
    end
    def encode_map(tree, list_mod) do
        map = Map.put_new(%{<<tree::utf8>> => list_mod}, <<tree::utf8>>, [0])   # Map char and freq 
    end

    # Buiding decoding table (same as encoding table)
    def decode_table(tree) do
        encode_table(tree)
    end

    # Encoding text
    def encode(text, []) do
        "No encoding table"
    end
     def encode([], []) do
        "No text and encoding table"
    end
     def encode([], encode) do
        "No text to encode"
    end
    def encode(text, encode) do
        encode(text, encode, [])
    end
    def encode([], encode, seq) do
        seq
    end
    def encode([char|rest],encode, seq) do
        s = seq ++ elem(Map.fetch(encode, <<char :: utf8>>), 1) # Fetch char in map and append seq
        encode(rest, encode, s)
    end

    # Decoding text
    def decode([], decode, b, text)  do
        List.to_string(text)
    end
    def decode(seq, decode)  do
        decode(seq, decode, [], [])
    end
    def decode([bit|rest], decode, bits, text) do
        b = bits ++ [bit]                                      
        char = Enum.find(decode, fn {key, val} -> val == b end) # Find char in map that has the exact kombination of bits b

        if(char !== nil) do                 # If char exist 
            t = text ++ [elem(char, 0)]     # append char to text
            b_next = []                         # move to next sequence of bits by clearing bit list
            decode(rest,decode, b_next, t )
        else
            decode(rest,decode, b, text)    # If char does not exist add next bit to bit list
        end
    end

end
