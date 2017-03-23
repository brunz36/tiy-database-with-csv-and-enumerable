require 'csv'

class Person
  attr_reader "name", "phone_number", "address", "position", "salary", "slack_acct", "github_acct"

  def initialize(name, phone_number, address, position, salary, slack_acct, github_acct)
    @name = name
    @phone_number = phone_number
    @address = address
    @position = position
    @salary = salary
    @slack_acct = slack_acct
    @github_acct = github_acct
  end
end

class Database
  attr_reader "search_name", "found"

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
    @found = found
  end

  def add_person
    found = true
    while found == true
      print "Please input a name, when finished leave blank: "
      name = gets.chomp.capitalize

      if name.empty?
        found = false
        next
      end

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

      puts ""

      person = Person.new(name, phone_number, address, position, salary, slack_acct, github_acct)

      @person_array << person
    end

  end

  def search_person
    found = false
    print "Please input the name of the person you want to search: "
    search_person = gets.chomp

    @person_array.each do |person|
      if person.name == search_person
        found = true
        puts "This is #{person.name}'s information.
        \nName: #{person.name}
        \nPhone: #{person.phone_number}
        \nAddress: #{person.address}
        \nPosition: #{person.position}
        \nSalary: #{person.salary}
        \nSlack Account: #{person.slack_acct}
        \nGitHub Account: #{person.github_acct}"
      end
    end

    if found == false
      puts "\n#{search_person} is not in our system.\n"
    end
  end

  def delete_person
    found = false
    print "Please input the name of the person you want to delete: "
    delete_person = gets.chomp

    @person_array.each do |person|
      if person.name == delete_person
        found = true
        @person_array.delete(person)
      end
    end

    if found == false
      puts "\n#{delete_person} is not in our system.\n"
    end

  end

  def quit_program
    puts "Thank you for your input."

    CSV.open("employees.csv", "w") do |row|
      row << ["Name", "Phone Number", "Address", "Position", "Salary", "Slack Account", "GitHub Account"]
      @person_array.each do |person|
        row << [person.name, person.phone_number, person.address, person.position, person.salary, person.slack_acct, person.github_acct]
      end
    end
  end
end

class Menu
  def initialize
    @database = Database.new
    @menu = true
  end

  def menu_selection
    while @menu == true
      puts "\nPlease type what you would like to do: "
      puts %{
        A: Add a person
        S: Search for a person
        D: Delete a person
        Q: Quit
      }
      print ">> "
      selected = gets.chomp.downcase

      if selected == "a"
        @database.add_person
      elsif selected == "s"
        @database.search_person
      elsif selected == "d"
        @database.delete_person
      elsif selected == "q"
        @database.quit_program
        @menu = false
      else
        puts "Please only select: A | S | D | Q"
      end
    end
  end
end

instance = Menu.new

instance.menu_selection
