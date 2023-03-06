# Set up the game window
game_width <- 40
game_height <- 20
game <- matrix(" ", game_height, game_width)

# Set up the player and asteroid positions
player_x <- round(game_width / 2)
player_y <- game_height - 2
game[player_y, player_x] <- "^"
asteroid_x <- sample(1:game_width, 1)
asteroid_y <- 2
game[asteroid_y, asteroid_x] <- "*"

# Function to move the player left or right
move_player <- function(direction) {
  if (direction == "left") {
    if (player_x > 1) {
      game[player_y, player_x] <- " "
      player_x <- player_x - 1
      game[player_y, player_x] <- "^"
      return(TRUE)
    } else {
      return(FALSE)
    }
  } else if (direction == "right") {
    if (player_x < game_width) {
      game[player_y, player_x] <- " "
      player_x <- player_x + 1
      game[player_y, player_x] <- "^"
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}

# Function to move the asteroid down
move_asteroid <- function() {
  if (asteroid_y < game_height) {
    game[asteroid_y, asteroid_x] <- " "
    asteroid_y <- asteroid_y + 1
    game[asteroid_y, asteroid_x] <- "*"
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# Game loop
while (TRUE) {
  # Print the game window and instructions
  cat("\n")
  cat(paste(apply(game, 1, paste, collapse=""), collapse="\n"))
  cat("\n")
  cat("Use left and right arrow keys to move (q to quit)")
  
  # Wait for user input
  key <- readChar(1)
  
  # Update the player position based on the user input
  if (key == "q") {
    break
  } else if (key == "\033[D") {
    move_player("left")
  } else if (key == "\033[C") {
    move_player("right")
  }
  
  # Move the asteroid and check for collision
  if (!move_asteroid()) {
    cat("\n")
    cat("Game over! Asteroid hit the ground.\n")
    break
  } else if (asteroid_y == player_y && asteroid_x == player_x) {
    cat("\n")
    cat("Game over! Asteroid hit the player.\n")
    break
  }
}
