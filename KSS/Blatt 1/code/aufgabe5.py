import math
from itertools import combinations

def aufgabe5naive(N):
  T_6 = math.floor(N / 6)
  T_10 = math.floor(N / 10)
  T_14 = math.floor(N / 14)
  T_22 = math.floor(N / 22)
  T_30 = math.floor(N / 30)
  T_42 = math.floor(N / 42)
  T_66 = math.floor(N / 66)
  T_70 = math.floor(N / 70)
  T_110 = math.floor(N / 110)
  T_154 = math.floor(N / 154)
  T_210 = math.floor(N / 210)
  T_462 = math.floor(N / 462)
  T_330 = math.floor(N / 330)
  T_770 = math.floor(N / 770)
  T_2310 = math.floor(N / 2310)
  print( T_6 + T_10 + T_14 + T_22 - T_30 - T_42 - T_66 - T_70 - T_110 - T_154 + T_210 + T_462 + T_330 + T_770 - T_2310 )

def aufgabe5compact(N):
  divs = [6,10,14,22]
  res = 0;
  # Jede moegliche Tupellaenge durchlaufen
  for k in range(1,len(divs)+1):
    count = 0;
    # Durch jede Kombination von groesse k iterieren
    for combo in combinations(divs,k):
      count += math.floor(N / math.lcm(*combo))
    res += count * (-1)**(k-1)
  print(res)