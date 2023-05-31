import random

vergleiche = 0


def quicksort(arr):
    # Basisfall
    if len(arr) <= 1:
        return arr

    # Zufaelliges Element der Liste
    pivot = random.choice(arr)

    # Listen fuer die Elemente, die kleiner, groesser oder gleich dem Pivot sind
    left = []
    right = []
    equal = []

    # Zaehlen der Vergleiche
    global vergleiche
    vergleiche += len(arr) - 1
    
    for x in arr:
        if x < pivot:
            left.append(x)
        elif x > pivot:
            right.append(x)
        else:
            equal.append(x)

    # Rekursiver Aufruf
    return quicksort(left) + equal + quicksort(right)




# Fuers testen
n = 1000
a = [random.randint(0, n) for i in range(n)]

quicksort(a)

print(vergleiche)
