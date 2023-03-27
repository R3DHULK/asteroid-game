import pygame
import random

# initialize pygame
pygame.init()

# game constants
WIDTH = 800
HEIGHT = 600
FPS = 60

# create the window
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Asteroids")

# set up clock
clock = pygame.time.Clock()

# create player sprite
class Player(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((50, 50))
        self.image.fill((255, 255, 255))
        self.rect = self.image.get_rect()
        self.rect.center = (WIDTH / 2, HEIGHT / 2)

    def update(self):
        # handle player movement
        keys = pygame.key.get_pressed()
        if keys[pygame.K_LEFT]:
            self.rect.x -= 5
        if keys[pygame.K_RIGHT]:
            self.rect.x += 5
        if keys[pygame.K_UP]:
            self.rect.y -= 5
        if keys[pygame.K_DOWN]:
            self.rect.y += 5

# create asteroid sprite
class Asteroid(pygame.sprite.Sprite):
    def __init__(self):
        pygame.sprite.Sprite.__init__(self)
        self.image = pygame.Surface((30, 30))
        self.image.fill((255, 0, 0))
        self.rect = self.image.get_rect()
        self.rect.x = random.randrange(WIDTH - self.rect.width)
        self.rect.y = random.randrange(-100, -40)
        self.speedy = random.randrange(1, 8)

    def update(self):
        # handle asteroid movement
        self.rect.y += self.speedy
        if self.rect.top > HEIGHT + 10:
            self.rect.x = random.randrange(WIDTH - self.rect.width)
            self.rect.y = random.randrange(-100, -40)
            self.speedy = random.randrange(1, 8)

# create sprite groups
all_sprites = pygame.sprite.Group()
asteroids = pygame.sprite.Group()

# create player sprite and add to sprite groups
player = Player()
all_sprites.add(player)

# create asteroid sprites and add to sprite groups
for i in range(8):
    asteroid = Asteroid()
    all_sprites.add(asteroid)
    asteroids.add(asteroid)

# game loop
running = True
while running:
    # set up clock
    clock.tick(FPS)

    # process input
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # update sprites
    all_sprites.update()

    # check for collisions
    hits = pygame.sprite.spritecollide(player, asteroids, False)
    if hits:
        running = False

    # render screen
    screen.fill((0, 0, 0))
    all_sprites.draw(screen)

    # flip the display
    pygame.display.flip()

# quit pygame
pygame.quit()
