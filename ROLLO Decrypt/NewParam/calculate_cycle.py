from math import *

# this file intends to estimate the total clock cycles used for ROLLO decapsulation

#set up basic configurations for system parameters.
N = [83, 97, 113, 189, 193, 211]
M = [67, 79, 97, 83, 97, 97]
R = [7, 8, 9, 7, 8, 8]
D = [8, 8, 9, 8, 8, 9]
x = 16
# DELTA has 6*(d-1) elts, non-constant style
# DELTA = [ [ N[0], 45, 34, 23, 13, 7, 7 ], \
# [ N[1], 49, 34, 19, 8, 8, 8 ], \
# [ N[2], 65, 49, 33, 17, 9, 9, 9 ], \
# [ N[3], 29, 7, 7, 7, 7, 7 ], \
# [ N[4], 31, 8, 8, 8, 8, 8 ], \
# [ N[5], 47, 22, 8, 8, 8, 8, 8 ] ]

# DELTA has 6*(d-1) elts, basic constant style (2N)
# DELTA = [ [N[0]] + [N[0]]*(D[0]-2), \
# [N[1]] + [N[1]]*(D[1]-2), \
# [N[2]] + [N[2]]*(D[2]-2), \
# [N[3]] + [N[3]]*(D[3]-2), \
# [N[4]] + [N[4]]*(D[4]-2), \
# [N[5]] + [N[5]]*(D[5]-2) ]

# DELTA has 6*(d-1) elts, faster constant style (N+R*D)
DELTA = [ [N[0]] + [R[0]*D[0]]*(D[0]-2), \
[N[1]] + [R[1]*D[1]]*(D[1]-2), \
[N[2]] + [R[2]*D[2]]*(D[2]-2), \
[N[3]] + [R[3]*D[3]]*(D[3]-2), \
[N[4]] + [R[4]*D[4]]*(D[4]-2), \
[N[5]] + [R[5]*D[5]]*(D[5]-2) ]



mem_cycle = 2
gf2m_mul_cycle = [ceil(1.0*m/16)+1 for m in M]
GF2mz_mul_cycle = [2452, 2984, 5018, 12544, 14122, 17806]

print (gf2m_mul_cycle)
#RSR part

# compute S_i = f_i^-1*S  calculate S1,S2 and then move to mem S1S2
Si_cycle = [ d*((mul+2)*n+(mem_cycle+2)) + d*(n+mem_cycle) for n,mul,d in zip(N,gf2m_mul_cycle,D) ]

# compute the matrix trianglarization
K = [] # K is a two dimensional array with 6 smaller lists
for i in range(6):
	tmp = []
	d = D[i]
	for j in range(d-1):
		delta = DELTA[i][j]	
		tmp.append(delta+N[i]) 
	K.append(tmp)


L = [ 2*m for m in M ]

triangular = [0]*6
for i in range(6):
	d = D[i]
	for j in range(0,d-1): # for each ROLLO, d-1 triangularizations are performed 
		# approximation value of triangularization
		# triangular[i] +=  (2*K[i][j]*L[i]+K[i][j]**2)/(2.0*x) + 3*K[i][j]

		# exact value of triangularization
		for p in range(1,int(ceil(1.0*K[i][j]/x))+1):	 
			triangular[i] +=  L[i] + ceil(1.0*K[i][j]/x)*x + (3-p)*x + mem_cycle-1
		# triangular[i] += 1 + (3*x + 2*L[i] + mem_cycle-2)

# write back E to first few rows of memory, parallelizing with S3,S4,...,Sd generation
write_E_cycle = [ (d-2)*(n+mem_cycle) for r,d,n in zip(R,D,N) ] # d-1 intersections require d-2 writeback

# final matrix systemization
systemize = [ 3*x + 2*2*m + mem_cycle - 2 for m in M ]

# sha3
sha3 = [27*r for r in R]

TOTAL = [sum(z) for z in zip(GF2mz_mul_cycle, Si_cycle, triangular, write_E_cycle, systemize, sha3)]

for i in range(6):
	print ("GF2mz_mul_cycle: %d\t Si_cycle: %d\t triangular+write_E_cycle+systemize: %d\t sha3: %d\t TOTAL: %d\t" \
		%(GF2mz_mul_cycle[i], Si_cycle[i], triangular[i]+write_E_cycle[i]+systemize[i], sha3[i], TOTAL[i]))
	print ("")

for i in range(6):
	print (triangular[i])
print ("")
for i in range(6):
	print (write_E_cycle[i])
print ("")
for i in range(6):
	print (systemize[i])
print ("")