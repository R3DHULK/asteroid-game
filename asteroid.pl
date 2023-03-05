#!/usr/bin/perl

use strict;
use warnings;
use Curses;

# Initialize the screen
initscr();
noecho();
cbreak();
curs_set(0);
keypad(STDIN, 1);

# Set up the game variables
my $max_x = getmaxx();
my $max_y = getmaxy();
my $ship_x = int($max_x/2);
my $ship_y = $max_y - 1;
my $asteroids = [];
my $score = 0;
my $gameover = 0;

# Generate the initial asteroids
for (my $i = 0; $i < 10; $i++) {
    my $x = int(rand($max_x));
    my $y = int(rand($max_y/2));
    push(@$asteroids, [$x, $y]);
}

# Main game loop
while (!$gameover) {
    # Clear the screen
    clear();

    # Print the score
    mvprintw(0, 0, "Score: $score");

    # Draw the ship
    mvprintw($ship_y, $ship_x, "A");

    # Draw the asteroids
    foreach my $a (@$asteroids) {
        mvprintw($a->[1], $a->[0], "*");
    }

    # Move the asteroids
    for (my $i = 0; $i < scalar(@$asteroids); $i++) {
        my $a = $asteroids->[$i];
        $a->[1]++;
        if ($a->[1] >= $max_y) {
            # Asteroid has reached the bottom of the screen
            $a->[0] = int(rand($max_x));
            $a->[1] = 0;
        }
        # Check for collision with the ship
        if ($a->[0] == $ship_x && $a->[1] == $ship_y) {
            $gameover = 1;
        }
        # Check for collision with other asteroids
        for (my $j = 0; $j < scalar(@$asteroids); $j++) {
            next if $i == $j;
            my $b = $asteroids->[$j];
            if ($a->[0] == $b->[0] && $a->[1] == $b->[1]) {
                $a->[0] = int(rand($max_x));
                $a->[1] = 0;
                last;
            }
        }
    }

    # Get user input
    my $ch = getch();
    if ($ch == KEY_LEFT && $ship_x > 0) {
        $ship_x--;
    } elsif ($ch == KEY_RIGHT && $ship_x < $max_x-1) {
        $ship_x++;
    }

    # Increase the score for every frame survived
    $score++;

    # Refresh the screen
    refresh();

    # Wait for a short time before drawing the next frame
    usleep(100000);
}

# Game over message
clear();
mvprintw($max_y/2, $max_x/2 - 6, "Game Over!");
mvprintw($max_y/2+1, $max_x/2 - 11, "Final Score: $score");
refresh();
getch();

# Clean up
endwin();
