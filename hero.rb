require './entity'

class Hero < Entity
  def move()
    #Check if hero can move
    if @hp > 0
      @position += 1
    end
  end
end
