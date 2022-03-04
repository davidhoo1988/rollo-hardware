from math import *

# this file intends to estimate the total clock cycles used for ROLLO encapsulation

N = [83, 97, 113, 189, 193, 211]
M = [67, 79, 97, 83, 97, 97]
R = [7, 8, 9, 7, 8, 8]
D = [8, 8, 9, 8, 8, 9]

generate_E = [19*r+2 for r in R]
Gauss_Elim = [3*r+2*m+4 for r,m in zip(R,M)]
sha3 = [27*r+2 for r in R]
generate_e1e2 = [38*ceil(1.0*(n-r+1)/floor(1.0*96/r)) for n, r in zip(N,R)]
GF2mz_mul = [2452, 2984, 5018, 12544, 14122, 17806]
GF2mz_add = [3*ceil(1.0*n/r) for n, r in zip(N,R)]
TOTAL = [sum(x) for x in zip(generate_E, Gauss_Elim, sha3, generate_e1e2, GF2mz_mul, GF2mz_add)]

for i in range(2*3):
    print ("generate_E: %d\t Gauss_Elim: %d\t sha3: %d\t generate_e1e2: %d\t GF2mz_mul: %d\t GF2mz_add: %d\t TOTAL: %d\t" \
        %(generate_E[i], Gauss_Elim[i], sha3[i], generate_e1e2[i], GF2mz_mul[i], GF2mz_add[i], TOTAL[i]))
    print ("")