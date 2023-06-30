import random
import math

def calc_pi(N):
    T = 0
    for i in range(N):
        x = random.random()
        y = random.random()
        if math.sqrt(x**2 + y**2) <= 1:
            T += 1
    pi = 4 * T / N
    return pi

# Aufruf mit 100000 Wiederholungen
print(calc_pi(100000))
