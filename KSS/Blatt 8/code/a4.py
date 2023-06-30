import random

def experiment(n): # a)
    anz = 0
    for i in range(n):
        anz += random.randint(0, 1)
    return anz/n

n = 2605 # b)
imBereich = 0
for i in range(100):
    if abs(experiment(n) - 0.5) <= 0.01:
        imBereich += 1
print(imBereich/100) # Ungefaehr 0.7
