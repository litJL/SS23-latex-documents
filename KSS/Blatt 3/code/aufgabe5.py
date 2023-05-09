import scipy.special as sc # Needed for binom

def S(n,m):
  # Base cases
  if (n != 0 and m == 0) or (n < m):
    return 0
  
  if (n == 0 and m == 0) or (n == m):
    return 1
  
  # Recursion 
  return S(n-1,m-1) + m * S(n-1,m)

def B(n):
  total = 0
  
  for i in range(n+1):
    total += S(n,i)
  
  return total

# Implementation for Bell numbers according to 1b)
def B1b(n):
  if n == 0:
    return 1
  
  total = 0
  for k in range(0,n):
    total += sc.binom(n-1,k) * B1b(k)
  
  return total

# Compare the two implementations with the number we get in 1c)
print(B(4),B1b(4)) # 15 15
print(B(10))       # 115975 