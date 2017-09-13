class Entity
  attr_reader :position, :hp, :damage, :name

  def set_position=(position)
    @position = position
  end

  def set_hp=(hp)
    @hp = hp
  end

  def set_damage=(damage)
    @damage = damage
  end

  def set_name=(name)
    @name = name
  end

  def reduce_hp(damage)
    @hp -= damage
  end

  def attack(enemy)
    enemy.reduce_hp(@damage)
  end
end
