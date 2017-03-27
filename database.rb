require 'csv'

class Person
  attr_reader "name", "phone_number", "address", "position", "salary", "slack_acct", "github_acct"

  def initialize(name, phone_number, address, position, salary, slack_acct, github_acct)
    @name = name
    @phone_number = phone_number.to_i
    @address = address
    @position = position
    @salary = salary.to_i
    @slack_acct = slack_acct
    @github_acct = github_acct
  end
end

class Database
  attr_reader "search_name"

  def initialize
    @person_array = []
    CSV.foreach("employees.csv", headers: true) do |row|
      name = row["Name"]
      phone_number = row["Phone Number"]
      address = row["Address"]
      position = row["Position"]
      salary = row["Salary"]
      slack_acct = row["Slack Account"]
      github_acct = row["GitHub Account"]

      person = Person.new(name, phone_number, address, position, salary, slack_acct, github_acct)

      @person_array << person
    end
  end

  def add_person
    print "Please input a name: "
    name = gets.chomp

    if @person_array.find { |person| person.name == name }
      puts "\n#{name} is alredy in our system."
    else
      print "Input a phone number with area code, eg. 7278475464: "
      phone_number = gets.chomp.to_i

      print "Input the address, eg. 260 1st Ave S, St. Petersburg, FL 33701: "
      address = gets.chomp

      print "Input the position, eg. Instructor, Student, TA, or Campus Director: "
      position = gets.chomp

      print "Input the salary: "
      salary = gets.chomp.to_i

      print "Input the Slack account: "
      slack_acct = gets.chomp

      print "Input the GitHub account: "
      github_acct = gets.chomp

      person = Person.new(name, phone_number, address, position, salary, slack_acct, github_acct)

      @person_array << person
    end

  end

  def search_person
    print "Please input the username of their Slack, GitHub account or the name of the person you want to search: "
    search_person = gets.chomp

    multiple_persons = @person_array.find_all {|x| (x.name.include?(search_person)) || (x.slack_acct.include?(search_person)) || (x.github_acct.include?(search_person))}

    if multiple_persons.empty?
      puts "\nThe search for \"#{search_person}\", yielded zero results."
    else
      puts "\nHere are the results of your search including: #{search_person}."
      puts ""
      multiple_persons.each do |person|
        puts "Name: #{person.name}".ljust(20) + "| Phone Number: #{person.phone_number}".ljust(27) + "| Adress: #{person.address}".ljust(50) + "| Position: #{person.position}".ljust(28) + "| Salary: $#{person.salary}".ljust(17) + "| Slack Account: #{person.slack_acct}".ljust(28) + "| GitHub Account: #{person.github_acct}"
      end
    end
  end

  def delete_person
    print "Please input the name of the person you want to delete: "
    delete_person = gets.chomp

    if @person_array.any? { |person| person.name == delete_person}
      @person_array.delete_if { |person| person.name == delete_person}
      print "Deleted person: #{delete_person}\n"
    else
      print "\n#{delete_person} is not in our system.\n"
    end
  end

  def report
    puts "\nHere is a list of the individuals associated with The Iron Yard."
    @person_array.each do |person|
      puts "Name: #{person.name}".ljust(20) + "| Phone Number: #{person.phone_number}".ljust(27) + "| Adress: #{person.address}".ljust(50) + "| Position: #{person.position}".ljust(28) + "| Salary: $#{person.salary}".ljust(17) + "| Slack Account: #{person.slack_acct}".ljust(28) + "| GitHub Account: #{person.github_acct}"
    end

    instructor = @person_array.select { |person| person.position == "Instructor" }
    instructor_salary = instructor.map { |wages| wages.salary }
    instructor_salary_all = instructor_salary.sum

    director = @person_array.select { |person| person.position == "Campus Director"}
    director_salary = director.map { |wages| wages.salary }
    director_salary_all = director_salary.sum

    student = @person_array.select { |person| person.position == "Student"}

    puts "\nThe total sum of the Instructors salary at The Iron Yard is: $#{instructor_salary_all}."
    puts "The total sum of the Campus Directors salary at The Iron Yard is: $#{director_salary_all}."

    puts "\nThere are a total of #{instructor.count} Instructors at The Iron Yard."
    puts "There are a total of #{director.length} Campus Directors at The Iron Yard."
    puts "There are a total of #{student.length} students at The Iron Yard."
  end

  def write_file
    CSV.open("employees.csv", "w") do |row|
      row << ["Name", "Phone Number", "Address", "Position", "Salary", "Slack Account", "GitHub Account"]
      @person_array.each do |person|
        row << [person.name, person.phone_number, person.address, person.position, person.salary, person.slack_acct, person.github_acct]
      end
    end
  end

  def write_file_html
    fileHtml = File.new("/public/report.html", "w+")

    fileHtml.puts %{<html>}
    fileHtml.puts %{<head lang="en">}
    fileHtml.puts %{<meta charset="UTF-8">}
    fileHtml.puts %{<meta name="viewport" content="width=device-width, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0">}
    fileHtml.puts %{<title>Tiy Database With Csv And Enumerable</title>}
    fileHtml.puts %{<link rel="stylesheet" href="/screen.css">}
    fileHtml.puts %{</head>}
    fileHtml.puts %{<body>}
    fileHtml.puts %{<ul>}
    @person_array.each do |person|
      fileHtml.print %{<li>}
      fileHtml.print "Name: #{person.name}".ljust(20) + "| Phone Number: #{person.phone_number}".ljust(27) + "| Adress: #{person.address}".ljust(50) + "| Position: #{person.position}".ljust(28) + "| Salary: $#{person.salary}".ljust(17) + "| Slack Account: #{person.slack_acct}".ljust(28) + "| GitHub Account: #{person.github_acct}"
      fileHtml.print %{</li>}
    end
    fileHtml.puts %{</ul>}
    fileHtml.puts %{</body>}
    fileHtml.puts %{</html>}

    fileHtml.close()
  end
end

class Menu
  def initialize
    @database = Database.new
    @menu = true
  end

  def menu_selection
    while @menu == true
      puts "\nPlease type what you would like to do:"

      puts "\n\tA: Add a person"
      puts "\tS: Search for a person"
      puts "\tD: Delete a person"
      puts "\tR: Report"
      puts "\tQ: Quit"

      print "\n>> "
      selected = gets.chomp.downcase

      if selected == "a"
        @database.add_person
        @database.write_file
      elsif selected == "s"
        @database.search_person
      elsif selected == "d"
        @database.delete_person
        @database.write_file
      elsif selected == "r"
        @database.report
        @database.write_file_html
      elsif selected == "q"
        @menu = false
        puts "Thank you for your input."
      else
        puts "Please only select: A | S | D | Q"
      end
    end
  end
end

instance = Menu.new

instance.menu_selection
