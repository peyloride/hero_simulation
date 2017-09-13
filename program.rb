require './hero'
require './enemy'

input_file_name = ARGV[0]
output_file_name = ARGV[1]

if ARGV.length != 2
  puts "We need exactly two arguments"
  puts "Input file name"
  puts "Output file name"
  exit
end

#initialize empty array for storing enemies
enemies = []

#read file as lines and reverse it because we want to check how many enemies do we have first
input_lines = File.readlines(input_file_name).reverse
size = input_lines.size

#Get static information about hero
resource = input_lines[size-1].split[2].to_i
hero_hp = input_lines[size-2].split[2].to_i
hero_damage = input_lines[size-3].split[3].to_i
hero_position = 0

#Iterate over every line get information about enemies
input_lines.each do |line|
  #Check if there is a line starting with "There is a", and get Enemy name and position, respectively
  if line =~ /^There is a/
    enemy = Enemy.new
    enemy.set_name = line.split[3]
    enemy.set_position = line.split[6].to_i
    enemies << enemy
  end

  #From enemy's name, get its HP and Damage power
  enemies.each do |enemy_kind|
    if line =~ Regexp.new(enemy_kind.name + " has")
      selected_enemies = enemies.find_all { |enemy| enemy.name == enemy_kind.name}
      selected_enemies.each do |selected_enemy|
        selected_enemy.set_hp = line.split[2].to_i
      end
    end

    if line =~ Regexp.new(enemy_kind.name + " attack")
      selected_enemies = enemies.find_all { |enemy| enemy.name == enemy_kind.name}
      selected_enemies.each do |selected_enemy|
        selected_enemy.set_damage = line.split[3].to_i
      end
    end
  end
end

#Initialize hero as new object
hero = Hero.new()
hero.set_name = "Hero"
hero.set_hp = hero_hp
hero.set_damage = hero_damage
hero.set_position = hero_position

#Open file for writing
output = open(output_file_name, 'w+')

#Start the simulation of hero
output.write("#{hero.name} started journey with #{hero.hp} HP!\n")
puts "#{hero.name} started journey with #{hero.hp} HP!\n"

for i in 0..resource do
  #Move hero 1 meters at a time
  hero.move()

  enemies.each do |enemy|
    #Check if there is an enemy at hero's current location
    if enemy.position == hero.position
      #Fight must go on until someone dies
      until enemy.hp <= 0 || hero.hp <= 0
        enemy.attack(hero)
        hero.attack(enemy)
        if enemy.hp <= 0
          puts "#{hero.name} defeated #{enemy.name} with #{hero.hp} HP remaining"
          output.write("#{hero.name} defeated #{enemy.name} with #{hero.hp} HP remaining\n")
        end
        if hero.hp <= 0
          puts "#{enemy.name} defeated #{hero.name} with #{enemy.hp} HP remaining"
          output.write("#{enemy.name} defeated #{hero.name} with #{enemy.hp} HP remaining\n")
          puts "#{hero.name} is Dead!! Last seen at position #{hero.position}!!"
          output.write("#{hero.name} is Dead!! Last seen at position #{hero.position}!!")
          break
        end
      end
    end
  end

  #Check if hero can reach resource's location
  if hero.position == resource
    puts "#{hero.name} Survived!"
    output.write("#{hero.name} Survived!")
  end
end
