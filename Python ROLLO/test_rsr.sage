import hashlib
import sha3 # pip install sha3 package first
import time

def ffi_elt_set_random(GF2m):
	# use as input the object of GF2m
	m = GF2m.degree()
	rng = ''
	for i in range(m):
		rng += str(randint(0, 1))
	tmp = list( int(s) for s in rng[0:m] )
	return GF2m(tmp)


def ffi_vec_directsum(ffi_vec_M, ffi_vec_N):
	return ffi_vec_M + ffi_vec_N

def ffi_vec_tensor_mul(ffi_vec_M, ffi_vec_N):
	m = len(ffi_vec_M)
	n = len(ffi_vec_N)
	ffi_vec_MN = (m*n) * [0]
	for i in range(m):
		for j in range(n):
			ffi_vec_MN[i*n + j] = ffi_vec_M[i] * ffi_vec_N[j]
	return ffi_vec_MN


def ffi_vec_rref(ffi_vec_M):
	#transfer ffi_vec M to its reduced row-echleon form
	n = len(ffi_vec_M)
	ffi_elt = ffi_vec_M[0].parent()
	m = ffi_elt.degree()

	M = matrix(GF(2),n,m)
	for i in range(n):
		tmp = ffi_vec_M[i].polynomial().list()
		for j in range(len(tmp)):
			M[i,j] = tmp[j]
	M1 = M.echelon_form()
	m1 = M.rank()

	ffi_vec_M1 = m1*[0]
	for i in range(m1):
		ffi_vec_M1[i] = ffi_elt(M1[i,:].list())
	return ffi_vec_M1

def ffi_vec_set_random(GF2m, dim):
	#for ROLLO-III only, create a random ffi_vec with dim elements	
	ffi_vec = dim*[0]
	for i in range(dim):
		ffi_vec[i] = ffi_elt_set_random(GF2m)
	return ffi_vec

def	ffi_vec_set_random_full_rank(GF2m, dim):
	#create the full-rank matrix M with size dim*m
	m = GF2m.degree()
	
	while True:
		M = matrix(GF(2), dim, m)
		for i in range(dim):
			r = ffi_elt_set_random(GF2m).polynomial().list()
			for j in range(len(r)):
				M[i,j] = r[j]
		if M.rank() == dim:
			break

	ffi_vec = dim*[0]
	for i in range(dim):
		ffi_vec[i] = GF2m(list(M[i]))
	return ffi_vec

def ffi_vec_set_random_full_rank_with_one(GF2m, dim):
	#create the matrix M with size dim*m
	m = GF2m.degree()
	
	while True:
		M = matrix(GF(2), dim, m)
		for i in range(dim-1):
			r = GF2m.random_element().polynomial().list()
			for j in range(len(r)):
				M[i,j] = r[j]
		M[dim-1,0] = 1 # set M[dim-1,:] = one		
		if M.rank() == dim:
			break

	ffi_vec = dim*[0]
	for i in range(dim):
		ffi_vec[i] = GF2m(list(M[i]))
	return ffi_vec


def ffi_vec_set_random_from_support(F, n):
	#generate a vector with n GF2m elements with support F
	ffi_vec = n*[0]
	d = len(F)

	i = 0
	while i < d: #occupy randomly d positions of ffi_vec with coordinates of F
		rnd = randint(0, n-1)
		if ffi_vec[rnd] == 0:
			ffi_vec[rnd] = F[i]
			i += 1

	for i in range(n): #occupy the remaining n-d positions of ffi_vec with random linear combinations of coordinates of F
		if ffi_vec[i] == 0:
			tmp = 0
			for j in range(d):
				if randint(0,1) == 1:
					tmp += F[j]
			ffi_vec[i] = tmp
		
	return ffi_vec	

def ffi_vec_intersection(ffi_vec_U, ffi_vec_W):
	#ffi_elt = GF(2^m,'z', modulus=x^79+x^9+1)

	n_U = len(ffi_vec_U)
	n_W = len(ffi_vec_W)
	# Zassenhaus algorithm https://en.wikipedia.org/wiki/Zassenhaus_algorithm

	U = matrix(GF(2),n_U,m)
	for i in range(n_U):
		tmp = ffi_vec_U[i].polynomial().list()
		for j in range(len(tmp)):
			U[i,j] = tmp[j]
	
	W = matrix(GF(2),n_W,m)
	for i in range(n_W):
		tmp = ffi_vec_W[i].polynomial().list()
		for j in range(len(tmp)):
			W[i,j] = tmp[j]
	
	M = block_matrix([ [U, U], [W, 0] ])
	M1 = M.echelon_form()

	ffi_vec_UW = []
	for i in range(n_U+n_W):
		if M1[i,0:m] == zero_matrix(GF(2), 1, m) and M1[i,m:2*m] != zero_matrix(GF(2), 1, m):
			ffi_vec_UW.append( ffi_elt( M1[i,m:2*m].list() ) ) 
	return ffi_vec_UW

def rank_support_recover(syn, support_F, dim_E, dim_F):
	#start_time = time.clock()
	d = dim_F  
	r = dim_E
  # Step 2: Recover the vector space E
	# Compute the spaces Si = F[i]^(-1) * S (line 10)  	
	S_i = d*[0]
	for i in range(d):
		tmp = len(syn)*[0]
		for j in range(len(syn)):
			tmp[j] = support_F[i]^(-1) * syn[j]
		S_i[i] = tmp

	# Retrieve the support E by computing the intersection of the Si spaces (line 10)
	E = S_i[0]
	for i in range(1,d):
		E = ffi_vec_intersection(E, S_i[i])
	#end_time = time.clock()
	#print ("RSR algorithm consumes %f seconds." %(end_time - start_time))

	return ffi_vec_rref(E)


# generate a random LRPC syndrome with dim=r*d 
def syn_set_random(syn_size, support_E, support_F):
	n = syn_size

	#generate a random vector space with dimension of rd
	E = support_E
	F = support_F

	#generate a random ffi_vec s from the support EF with dim(s)=rd
	s = ffi_vec(0)

			
	x = ffi_vec_set_random_from_support(F,n)
	y = ffi_vec_set_random_from_support(F,n)
	e1 = ffi_vec_set_random_from_support(E,n)
	e2 = ffi_vec_set_random_from_support(E,n)

	s = ffi_vec(x)*ffi_vec(e1) + ffi_vec(y)*ffi_vec(e2)

	return [s.list(), E, F]

# rsr recovers the vector space E from s and F
def syn_dec(syn, support_E, dim_E, support_F, dim_F):
	E = rank_support_recover(syn, support_F, dim_E, dim_F) # return E in rref form
	if E == ffi_vec_rref(support_E):
		return 0 # success
	else: 
		print (len(E))
		return -1 # failure

def test(total, size_n, E, F):
	fail = 0
	for i in range(total):
		if i % 1000 == 0:
			print ("i = ", i)
		[syn, E, F] = syn_set_random(n, E, F)
		if len(ffi_vec_rref(syn)) == r*d:
			if syn_dec(syn, E, len(E), F, len(F)) != 0:
				fail = fail + 1
		else:	
			fail = fail + 1
	return fail

if __name__ == "__main__":
	#global variables
	n = 83
	m = 67
	r = 7
	d = 8


	#find the irreducible polynomail defining the finite field
	R = GF(2)['x']
	for p in R.polynomials(m):
		if p.is_irreducible():
			print(p)
			break

	for q in R.polynomials(n):
		if q.is_irreducible():
			print(q)
			break

	#generate the ring polynomial P over f2[x]
	ffi_elt = GF(2^m,'x', modulus=p)
	PR_F_2m = PolynomialRing(ffi_elt,'z')
	z = PR_F_2m.gen()
	f = PR_F_2m(q)
	ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(f))

	total, fail = 1000, 0
	E = ffi_vec_set_random_full_rank(ffi_elt, r)
	F = ffi_vec_set_random_full_rank(ffi_elt, d)
	start_time = time.process_time()
	fail = test(total, n, E, F)
	print ("decoding total run %d; fails %d." %(total, fail))
	end_time = time.process_time()
	print ("algorithm consumes %f seconds." %(end_time - start_time))


