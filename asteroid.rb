# define constants
SCREEN_WIDTH = 80
SCREEN_HEIGHT = 20
SHIP_CHAR = '^'
BULLET_CHAR = '|'
ASTEROID_CHAR = '*'

# define variables
ship_x = SCREEN_WIDTH / 2
bullet_x = nil
bullet_y = nil
asteroid_x = rand(SCREEN_WIDTH)
asteroid_y = 0
game_over = false
score = 0

# define helper methods
def draw_screen(ship_x, bullet_x, bullet_y, asteroid_x, asteroid_y, score)
  system('clear') || system('cls')

  # draw top border
  puts '-' * SCREEN_WIDTH

  # draw ship
  puts (' ' * ship_x) + SHIP_CHAR

  # draw bullet
  if bullet_x && bullet_y > 0
    (bullet_y - 1).times do
      puts ' '
    end
    puts (' ' * bullet_x) + BULLET_CHAR
  end

  # draw asteroid
  (asteroid_y - 1).times do
    puts ' '
  end
  puts (' ' * asteroid_x) + ASTEROID_CHAR

  # draw bottom border
  puts '-' * SCREEN_WIDTH

  # display score
  puts "Score: #{score}"
end

def move_bullet(bullet_x, bullet_y)
  return nil, nil if bullet_y == 0

  bullet_y -= 1
  return bullet_x, bullet_y
end

def move_asteroid(asteroid_x, asteroid_y)
  return rand(SCREEN_WIDTH), 0 if asteroid_y >= SCREEN_HEIGHT

  asteroid_y += 1
  return asteroid_x, asteroid_y
end

def detect_collision(ship_x, bullet_x, bullet_y, asteroid_x, asteroid_y)
  if bullet_x == asteroid_x && bullet_y == asteroid_y
    return true
  elsif ship_x == asteroid_x && ship_x == asteroid_x
    return true
  else
    return false
  end
end

# game loop
puts "Welcome to Asteroid!"
puts "Use left/right arrow keys to move the ship, and spacebar to fire."
puts "Avoid the asteroids and shoot them down to score points."
require 'io/console'
loop do
  # input
  input = STDIN.getch

  case input
  when 'q'
    break
  when "\e[C" # right arrow
    ship_x = [ship_x + 1, SCREEN_WIDTH - 1].min
  when "\e[D" # left arrow
    ship_x = [ship_x - 1, 0].max
  when ' ' # spacebar
    bullet_x = ship_x
    bullet_y = SCREEN_HEIGHT - 2
  end

  # update game state
  bullet_x, bullet_y = move_bullet(bullet_x, bullet_y) if bullet_x
  asteroid_x, asteroid_y = move_asteroid(asteroid_x, asteroid_y)
  if detect_collision(ship_x, bullet_x, bullet_y, asteroid_x, asteroid_y)
    game_over = true
  end

  if asteroid_y >= SCREEN_HEIGHT
    asteroid_x = rand(SCREEN_WIDTH)
    asteroid_y = 0
    score += 1
  end

  # draw screen
  draw_screen(ship_x, bullet_x, bullet_y, asteroid_x, asteroid_y, score)

  # check for game over
  if game_over
    puts "Game over! Score: #{score}"
    break
  end

  # delay for smooth animation
  sleep 0.05
end
