names = [["bruno", "joe"],["nancy", "dan"], ["bob", "thais", "jane"]]

y = "joe"
found = names.find_all {|x| x == y}

p found
