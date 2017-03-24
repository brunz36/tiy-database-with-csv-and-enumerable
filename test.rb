names = ["bruno", "joe", "nancy", "dan", "bob", "thais", "jane"]

found = names.select {|x| x.include? "a"}
fond = names.select { |x| x.grep(/^a/)}
p found
p fond
