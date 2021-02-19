---
date: 2020-03-28 10:10
description: A description of my first blog.
tags: Python, AI, NEAT, game dev
excerpt: Creating an AI to beat Flappy Bird game
---
# Flappy Bird NEAT-Python <a href="https://github.com/GiPyoK/Flappy-Bird-NEAT-Python" target="_blank"><i class="fab fa-github" style="font-size: 1em;"></i></a>
<html>
<img src="/images/Flappy Bird/NEAT Flappy Bird demo.gif" alt="Flappy Bird demo" width="480" height="480"><br>
</html>

This is a clone of flappy bird game incorporated with <html><a href="https://neat-python.readthedocs.io/en/latest/">NEAT(NeuroEvolution of Augmenting Topologies)-Python</a></html>. The position of the bird, top pipe and bottom pipe are fed to NEAT-Python to create artificial neural networks and determine when to jump.

In order to feed the game information to NEAT, I have to make the game first. With help of <html><a href="https://www.pygame.org/wiki/about">Pygame</a></html>, the mechanics of Flappy Bird can be easily built.

I created 3 classes `Bird`, `Pipe`, and `Base`. The  `Bird` class will handle the movement and the animation of the the bird. 


```python
class Bird:
    IMGS = BIRD_IMGS
    MAX_ROTATION = 25
    ROT_VEL = 20
    ANIMATION_TIME = 5

    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.tilt = 0
        self.tick_count = 0
        self.vel = 0
        self.height = self.y
        self.img_count = 0
        self.img = self.IMGS[0]

    # top right coner is (0,0)
    def jump(self):
        self.vel = -10.5 # negative value to go up
        self.tick_count = 0
        self.height = self.y

    def move(self):
        self.tick_count += 1

        # simultating bird jumping in an arc
        d = self.vel*self.tick_count + 1.5*self.tick_count**2

        if d >= 16:
            d = 16  # terminal velocity (does not accelerate downward more than 16)
        
        if d < 0 :
            d -= 2

        self.y += d # move the bird in y direction

        # if the bird is moving upward, or higher than the position before jump
        # tilt upward
        if d < 0 or self.y < self.height + 50:
            if self.tilt < self.MAX_ROTATION:
                self.tilt = self.MAX_ROTATION
        else: # tilt downward
            if self.tilt > -90:
                self.tilt -= self.ROT_VEL

    def draw(self, win):
        self.img_count += 1

        if self.img_count < self.ANIMATION_TIME:
            self.img = self.IMGS[0]
        elif self.img_count < self.ANIMATION_TIME*2:
            self.img = self.IMGS[1]
        elif self.img_count < self.ANIMATION_TIME*3:
            self.img = self.IMGS[2]
        elif self.img_count < self.ANIMATION_TIME*4:
            self.img = self.IMGS[1]    
        elif self.img_count == self.ANIMATION_TIME*4 + 1:
            self.img = self.IMGS[0]
            self.img_count = 0

        if self.tilt <= -80:
            self.img = self.IMGS[1]
            self.img_count = self.ANIMATION_TIME*2
        
        # rotate the bird image around the center, not top left 
        rotated_image = pygame.transform.rotate(self.img, self.tilt)
        new_rect = rotated_image.get_rect(center = self.img.get_rect(topleft = (self.x, self.y)).center)
        win.blit(rotated_image, new_rect.topleft)

    def get_mask(self):
        return pygame.mask.from_surface(self.img)
```

`Pipe` class will handle the movement (When playing the game, it looks like the bird is moving forward; however, it is the pipes that are actually moving backwards to create that illusion.), random generation of pipe height,  and check collision with the bird. 

```python
class Pipe:
    GAP = 200
    VEL = 5

    def __init__(self,x):
        self.x = x
        self.heigh = 0

        self.top = 0
        self.bottom = 0
        self.PIPE_TOP = pygame.transform.flip(PIPE_IMG, False, True)
        self.PIPE_BOTTOM = PIPE_IMG

        self.passed = False
        self.set_height()

    def set_height(self):
        self.height = random.randrange(50, 450)
        self.top = self.height - self.PIPE_TOP.get_height()
        self.bottom = self.height + self.GAP
    
    def move(self):
        self.x -= self.VEL

    def draw(self, win):
        win.blit(self.PIPE_TOP, (self.x, self.top))
        win.blit(self.PIPE_BOTTOM, (self.x, self.bottom))

    def collide(self, bird):
        bird_mask = bird.get_mask()
        top_mask = pygame.mask.from_surface(self.PIPE_TOP)
        bottom_mask = pygame.mask.from_surface(self.PIPE_BOTTOM)

        top_offset = (self.x - bird.x, self.top - round(bird.y))
        bottom_offset = (self.x - bird.x, self.bottom - round(bird.y))

        b_point = bird_mask.overlap(bottom_mask, bottom_offset)
        t_point = bird_mask.overlap(top_mask, top_offset)

        if t_point or b_point:
            return True
        
        return False
```

Lastly, `Base` class will handle the movement of the ground which will be in sync with the pipes and the animation of generating a continuous ground.

```python
class Base:
    VEL = 5
    WIDTH = BASE_IMG.get_width()

    def __init__(self, y):
        self.y = y
        self.x1 = 0
        self.x2 = self.WIDTH

    def move(self):
        self.x1 -= self.VEL
        self.x2 -= self.VEL

        if self.x1 + self.WIDTH < 0:
            self.x1 = self.x2 + self.WIDTH
        
        if self.x2 + self.WIDTH < 0:
            self.x2 = self.x1 + self.WIDTH

    def draw(self, win):
        win.blit(BASE_IMG, (self.x1, self.y))
        win.blit(BASE_IMG, (self.x2, self.y))
```

I also defined `draw_window` function to see the socre, generation, and population of the birds.

```python
def draw_window(win, birds, pipes, base, score, gen, population):
    win.blit(BG_IMG, (0,0))

    for pipe in pipes:
        pipe.draw(win)

    text = STAT_FONT.render("Score: " + str(score), 1, (255,255,255))
    win.blit(text, (WIN_WIDTH - 10 - text.get_width(), 10))

    text = STAT_FONT.render("Gen: " + str(gen), 1, (255,255,255))
    win.blit(text, (10, 10))

    text = STAT_FONT.render("Population: " + str(population), 1, (255,255,255))
    win.blit(text, (10, 50))

    for bird in birds:
        bird.draw(win)

    base.draw(win)
    pygame.display.update()
```

Now, the game mechinics are finished, it is time to connect the neural network to the game. In the `main` class, `fitness` of each `genome` is set to 0. 

```python
def main(genomes, config):
    global gen
    gen += 1
    nets = []
    ge =[]
    birds = []

    for _, genome in genomes:
        net = neat.nn.FeedForwardNetwork.create(genome, config)
        nets.append(net)
        birds.append(Bird(230, 350))
        genome.fitness = 0
        ge.append(genome)
```

There needs to be a some kind of measurement for the AI to know if the genome in that generation is doing good or bad. The `fitness` value is the measurement for the AI to determine which genomes to keep and bring them to next generation and which genomes to discard.

I implemented 2 ways for a bird to achieve higher `fitness` value. The first way is based on survival time. After a bird has moved once in a game loop, it gains 0.1  `fitness` value.

```python
def main(genomes, config):
# ...
while run:
# ...
        for x, bird in enumerate(birds):
              bird.move()
              ge[x].fitness += 0.1
```

The second way is when a bird passes through the pipes and gets a score. In this case the `fitness` value is incremented by 5, a large number compared to 0.1. Because the ultimate goal of this game is to get a high score, I chose to give significantly higher `fitness` value so that the neural network can train itself in a direction that is aligned with the game objective. 

```python
def main(genomes, config):
# ...
while run:
# ...
        if add_pipe:
            score += 1
            for g in ge:
                g.fitness += 5
```

So far, I have only introduced the ways to increase the `fitness` value. There will be a case where the fitness value will decrease, so that the AI will opt out the inferior genomes. Decrement of fitness value will happen when the bird collides with a pipe and dies.

```python
def main(genomes, config):
# ...
while run:
# ...
        for pipe in pipes:
            for x, bird in enumerate(birds):
                if pipe.collide(bird):
                    ge[x].fitness -= 1
                    birds.pop(x)
                    nets.pop(x)
                    ge.pop(x)
```

Finally, I defined `run` function to setup NEAT from `config-feedforward.txt` file.

```python
def run(config_path):
    config = neat.config.Config(neat.DefaultGenome,
                                neat.DefaultReproduction,
                                neat.DefaultSpeciesSet,
                                neat.DefaultStagnation,
                                config_path)

    population = neat.Population(config)    # set population
    population.add_reporter(neat.StdOutReporter(True))  # add reports to population
    stats = neat.StatisticsReporter()
    population.add_reporter(stats)
```

There are 3 main parameters to tune in order to optimize NEAT's learning capabilities. `pop-size` controls the number of birds in each generation. `bias_mutate_rate` controls the probability that mutation will change the bias of a node by adding a random value. `bias_replace_rate` controls the probability that mutation will replace the bias of a node with a newly chosen random value. 

This project was a fun project to get an introductory about neural networks. To tell the truth, Flappy Bird was a too simple for NEAT. When I cranked up the `pop-size` to 50, the first generation could play the game endlessly. In order to simulate learning process of NEAT, I limited the `pop-size` to 10 in the gif above.
