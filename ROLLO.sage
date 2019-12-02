reset()
import hashlib

#global variables
'''n = 47
m = 79
d = 6
r = 5'''
n = 67
m = 113
r = 7
d = 8

w = 7
wr = 8

#generate the ring polynomial P over f2[x]
'''ffi_elt = GF(2^m,'z', modulus=x^79+x^9+1)
PR_F_2m = PolynomialRing(ffi_elt,'x')
f = x^47 + x^5 + 1
ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(f))'''

ffi_elt = GF(2^m,'z', modulus=x^113+x^9+1)
PR_F_2m = PolynomialRing(ffi_elt,'x')
f = x^67 + x^5 + x^2 + x + 1
ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(f))

def ffi_vec_hash(ffi_vec_M):
	return hashlib.sha224( str(ffi_vec_M) ).hexdigest()

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
		ffi_vec[i] = GF2m.random_element()
	return ffi_vec

def	ffi_vec_set_random_full_rank(GF2m, dim):
	#create the matrix M with size dim*m
	m = GF2m.degree()
	
	while True:
		M = matrix(GF(2), dim, m)
		for i in range(dim):
			r = GF2m.random_element().polynomial().list()
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
	d = dim_F  
	r = dim_E
  # Step 1: Expand the vector space of syn to the vector space EF
	# Compute the spaces Si = F[i]^(-1) * S (line 10)  	
  	S_i = d*[0]
  	for i in range(d):
  		tmp = n*[0]
  		for j in range(n):
  			tmp[j] = support_F[i]^(-1) * syn[j]
  		S_i[i] = tmp

  	# Compute the union of Si,i+1, Si+1,i+2, Si,i+2
  	for i in range(d-2):
	  	tmp = ffi_vec_directsum( ffi_vec_intersection(S_i[i], S_i[i+1]), ffi_vec_intersection(S_i[i+1], S_i[i+2]) )
	  	tmp = ffi_vec_directsum( tmp, ffi_vec_intersection(S_i[i], S_i[i+2]) )
	  	tmp = ffi_vec_directsum( syn, ffi_vec_tensor_mul(support_F, tmp) )
  		if len(ffi_vec_rref(tmp)) < r*d or len(ffi_vec_rref(tmp)) == r*d:
  			syn = tmp
  			break


  # Step 2: Recover the vector space E
  	# Compute the spaces Si = F[i]^(-1) * S (line 10)  	
  	S_i = d*[0]
  	for i in range(d):
  		tmp = n*[0]
  		for j in range(n):
  			tmp[j] = support_F[i]^(-1) * syn[j]
  		S_i[i] = tmp
	# Retrieve the support E by computing the intersection of the Si spaces (line 10)
	E = S_i[0]
	for i in range(1,d):
		E = ffi_vec_intersection(E, S_i[i])
		if len(E) < r or len(E) == r:
			break
  	return ffi_vec_rref(E)

# ROLLO-I interfaces only
def ROLLO_I_keygen():
	#generate a random vector space with dimension of d
	F = ffi_vec_set_random_full_rank(ffi_elt, d)

	#generate two random ffi_vec x, y from the support F
	xx = ffi_vec_set_random_from_support(F,n)
	yy = ffi_vec_set_random_from_support(F,n)

	h = (1/ffi_vec(xx)) * ffi_vec(yy)
	hh = h.list()
	sk = [xx, yy, F]
	pk = [hh, f]

	return [pk, sk]

def ROLLO_I_encap(pk):
	#system parameter declaration	
	h = pk[0]
	P = pk[1]

	#generate a random vector space E with dimension of r
	E = ffi_vec_set_random_full_rank(ffi_elt, r)

	#generate two random ffi_vec e1, e2 from the support E
	e1 = ffi_vec_set_random_from_support(E,n)
	e2 = ffi_vec_set_random_from_support(E,n)

	c = ffi_vec(e1) + ffi_vec(e2)*ffi_vec(h)

	return [c.list(), ffi_vec_hash( ffi_vec_rref(E) )]

def ROLLO_I_decap(c, sk):

	x = sk[0]
	y = sk[1]
	F = sk[2] 

	#set s = xc mod P
	s = (ffi_vec(x) * ffi_vec(c)).list()
	E = rank_support_recover(s, F, r, d)
	return ffi_vec_hash(E)


# ROLLO-II interfaces only
def ROLLO_II_keygen():
	#generate a random vector space with dimension of d
	F = ffi_vec_set_random_full_rank(ffi_elt, d)

	#generate two random ffi_vec x, y from the support F
	xx = ffi_vec_set_random_from_support(F,n)
	yy = ffi_vec_set_random_from_support(F,n)

	h = (1/ffi_vec(xx)) * ffi_vec(yy)
	hh = h.list()
	sk = [xx, yy, F]
	pk = [hh, f]

	return [pk, sk]

def ROLLO_II_encap(str_M, pk):
	#system parameter declaration	
	h = pk[0]
	P = pk[1]

	#generate a random vector space E with dimension of r
	E = ffi_vec_set_random_full_rank(ffi_elt, r)

	#generate two random ffi_vec e1, e2 from the support E
	e1 = ffi_vec_set_random_from_support(E,n)
	e2 = ffi_vec_set_random_from_support(E,n)

	c = ffi_vec(e1) + ffi_vec(e2)*ffi_vec(h)

	#mask M by Hash(E)
	cipher = ''
	a = ''.join(format(ord(x), 'x') for x in str_M) #hex value of string M
	b = ffi_vec_hash( ffi_vec_rref(E) )# hex value of Hash(E) with E of rref
	for i in range(len(a)):
		y = int(a[i], 16) ^^ int(b[i], 16)
		cipher += '{0:x}'.format(y)
	cipher += b[len(a):]

	return [c.list(), cipher]

def ROLLO_II_decap(C, sk):
	#here C = [c, cipher]
	x = sk[0]
	y = sk[1]
	F = sk[2] 

	c = C[0]
	cipher = C[1]

	#set s = xc mod P
	s = (ffi_vec(x) * ffi_vec(c)).list()
	E = rank_support_recover(s, F, r, d)
	
	#unmask cipher to retrieve the message M
	M = ''
	b = ffi_vec_hash(E)
	for i in range(len(b)):
		y = int(cipher[i], 16) ^^ int(b[i], 16)
		M += '{0:x}'.format(y)

	return M.decode("hex") # turn ASCII string to plain ASCII


# ROLLO-III interfaces only
def ROLLO_III_keygen():
	#generate a random vector space F with dimension of w
	F = ffi_vec_set_random_full_rank_with_one(ffi_elt, w)

	#generate two random ffi_vec x, y from the support F
	xx = ffi_vec_set_random_from_support(F,n)
	yy = ffi_vec_set_random_from_support(F,n)

	#generate a random parity check matrix polynomial h
	hh = ffi_vec_set_random(ffi_elt, n)

	s = ffi_vec(xx) + ffi_vec(hh)*ffi_vec(yy)
	ss = s.list()
	sk = [xx, yy, F]
	pk = [hh, ss]

	return [pk, sk]


def ROLLO_III_encap(pk):
	#system parameter declaration	
	h = pk[0]
	s = pk[1]

	#generate a random vector space E with dimension of wr
	E = ffi_vec_set_random_full_rank(ffi_elt, wr)

	#generate two random ffi_vec e1, e2 from the support E
	r1 = ffi_vec_set_random_from_support(E,n)
	r2 = ffi_vec_set_random_from_support(E,n)
	er = ffi_vec_set_random_from_support(E,n)

	sr = ffi_vec(r1) + ffi_vec(r2)*ffi_vec(h)
	se = ffi_vec(er) + ffi_vec(r2)*ffi_vec(s)

	return [sr.list(), se.list(), ffi_vec_hash( ffi_vec_rref(E) )]


def ROLLO_III_decap(c, sk):
	sr = c[0]
	se = c[1]
	x = sk[0]
	y = sk[1]
	F = sk[2]

	#set ec = se - y*sr
	ec = (ffi_vec(se) - ffi_vec(y)*ffi_vec(sr)).list()

	#recover E from RSR(F, ec, wr)
	E = rank_support_recover(syn = ec, support_F = F, dim_E = wr, dim_F = w)
	return ffi_vec_hash(E)



# main function

[pk, sk] = ROLLO_I_keygen()
[c, E1] = ROLLO_I_encap(pk)
E2 = ROLLO_I_decap(c, sk)
if E1 == E2:
	print "ROLLO-I OK"
else:
	print "ROLLO-I not OK"



[pk, sk] = ROLLO_II_keygen()
[c, cipher] = ROLLO_II_encap('hello world!', pk)
msg = ROLLO_II_decap([c, cipher], sk)
if 'hello world!' in msg:
	print "ROLLO-II OK"
else:
	print "ROLLO-II not OK"	 


[pk, sk] = ROLLO_III_keygen()
[sr, se, E1] = ROLLO_III_encap(pk)
E2 = ROLLO_III_decap([sr, se], sk)
if E1 == E2:
	print "ROLLO-III OK"
else:
	print "ROLLO-III not OK"