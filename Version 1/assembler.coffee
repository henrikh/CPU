A = "A"
B = "B"
C = "C"
E = "E"

p = (x) -> console.log x

addrDecode = (addr) ->
 switch addr
  when "A" then "00"
  when "B" then "01"
  when "C" then "10"
  when "E" then "11"

place = (first, write, data) ->
 unless data? then data = "00000000"
 "000#{addrDecode first}11#{addrDecode write}#{data}"

add = (first, second, write, data) ->
 unless data? then data = "00000000"
 "001#{addrDecode first}#{addrDecode second}#{addrDecode write}#{data}"

negate = (first, write, data) ->
 unless data? then data = "00000000"
 "010#{addrDecode first}11#{addrDecode write}#{data}"

jumpZ = (data) ->
 unless data? then data = "00000000"
 "011111111#{data}"

jumpP = (data) ->
 unless data? then data = "00000000"
 "100111111#{data}"

il = [(place E, A, "00010100"),
(place E, B, "00000010"),
(negate B, B),
(add A, B, A),
(jumpP "00000011"),
]

for i in il
  console.log i
