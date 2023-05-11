import math


def mergeSort(A):
  n = len(A)
  
  if n == 1:
    return A
  
  m = math.floor(n/2)
  left = mergeSort(A[:m])
  right = mergeSort(A[m:])
  
  return merge(left,right)

def merge(A,B):
  n = len(A)
  m = len(B)
  i = j = 0
  C = []
  
  for k in range(n+m):
    
    if j == m or (i < n and A[i] <= B[j]):
      C.append(A[i])
      i += 1
    else:
      C.append(B[j])
      j += 1

  return C

print(mergeSort([1,3,2,5,4]))