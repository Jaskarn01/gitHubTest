def fact n
  if n==1
    return n
  end
  return n*fact(n-1)
end
def get_handshakes n
  if n==1
    return 0
  end
  return fact(n)/2
end

t = gets.chomp.to_i
result = []
for test in 0...t
  n = gets.chomp.to_i
  result.append get_handshakes(n)
end
for i in 0...t
  puts result[i]
end
