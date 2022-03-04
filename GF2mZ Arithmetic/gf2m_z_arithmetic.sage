reset()

def ffi_elt_list(ffi_elt, prep_mod = 'hex'): # transform ffi_elt element to list of binary-type elements (lsb-first).
	m = ffi_elt.parent().degree()
	string = '{{:0{0}b}}'.format(m)
	if prep_mod == 'bin':
		return string.format(ffi_elt.integer_representation())[::-1]
	else:
		return  hex(int(string.format(ffi_elt.integer_representation())[::-1], 2))
	

def ffi_vec_list(ffi_vec):
	tmp_list = list(ffi_vec)
	res_list = []
	for elt in tmp_list:
		res_list.append(ffi_elt_list(elt))
	return res_list


def shift_by_z(a, f, digit): # return a(z)*z^digit mod f
	a_list = list(a)
	n = len(a_list)
	f_list = [i for i, e in enumerate(f) if e != 0] # sparse list for polynomial f
	z = a.parent().gen()
	R = a.parent()

	if len(f_list) == 3: # if f is trinomial
		tmp_list = a_list[n-digit:n]
		a_list = a_list[n-digit:n-1 +1] + a_list[0:n-digit-1 +1]
		k = f_list[1]
		for j in range(digit):
			a_list[k+j] = a_list[k+j] + tmp_list[j]
		a_z = R(a_list)

	elif len(f_list) == 5: # if f is pentanomial
		tmp_list = a_list[n-digit:n]
		a_list = a_list[n-digit:n-1 +1] + a_list[0:n-digit-1 +1]
		for idx in range(1,4):
			k = f_list[idx]
			for j in range(digit):
				a_list[k+j] = a_list[k+j] + tmp_list[j]
		a_z = R(a_list)
	return a_z


# digit-by-digit MSG-first interleaved multiplication
def bit_lv_inter_mul(A,B,f):
	A_list = list(A)
	n = len(A_list)
	f_list = [i for i, e in enumerate(f) if e != 0] # sparse list for polynomial f
	z = A.parent().gen()
	R = A.parent()

	C = A_list[n-1]*B
	for i in range(n-2,-1,-1):
		if len(f_list) == 3: # if f is trionomial
			C_list = list(C)
			C_list = [C_list[n-1]] + C_list[0:n-1]
			k = f_list[1]
			C_list[k] = C_list[k] + C_list[0]
			Cz = R(C_list)
		elif len(f_list) == 5: # if f is pentanomial
			C_list = list(C)
			C_list = [C_list[n-1]] + C_list[0:n-1]
			for j in range(1,4):
				k = f_list[j]
				C_list[k] = C_list[k] + C_list[0]
			Cz = R(C_list)

		C = Cz + A_list[i]*B

	return C


def digit_lv_inter_mul(A,B,f,digit): #multiple digit-by-digit interleaved multiplication, improvement-I proposed in our paper
	ffi_vec = A.parent()
	z = A.parent().gen()
	C = 0
	A_list = list(A)
	B_list = list(B)
	d = digit
	Bz = B

	for i in range(ceil(n/d)):
		if i != ceil(n/d)-1:
			for j in range(d):
				C = C + A_list[i*d+j] * shift_by_z(Bz,f,j)
				if i == 1-1 and j == 1-1:
					print 'a{0} = '.format(i*d+j), ffi_elt_list(A_list[i*d+j])
					print 'B = ', ffi_vec_list(shift_by_z(Bz,f,j))
					print 'a{0}*B = '.format(i*d+j), ffi_vec_list(A_list[i*d+j] * shift_by_z(Bz,f,j))
			if i == 1-1:
				print 'C = ', ffi_vec_list(C)
		else: 
			for j in range(d):
				if i*d + j < n:
					C = C + A_list[i*d+j] * shift_by_z(Bz,f,j)
			# 		if i == ceil(n/d)-1:
			# 			print 'a{0} = '.format(i*d+j), ffi_elt_list(A_list[i*d+j])
			# 			print 'B = ', ffi_vec_list(shift_by_z(Bz,f,j))
			# 			print 'a{0}*B = '.format(i*d+j), ffi_vec_list(A_list[i*d+j] * shift_by_z(Bz,f,j))
			# if i == ceil(n/d)-1:
			# 	print 'C = ', ffi_vec_list(C)
		#update Bz = Bz * z^d
		Bz = shift_by_z(Bz,f,d)

	return C


def digit_lv_inter_mul2(A,B,f,digit): # digit-by-digit interleaved multiplication, improvement-II proposed in our paper
	ffi_vec = A.parent()
	z = A.parent().gen()
	C = 0
	A_list = list(A)
	d = digit
	n = len(A_list)
	#prepare d copies of the polynomial B(z)
	Bz = d*[0]
	for i in range(d):
		Bz[i] = shift_by_z(B,f,i)

	for i in range(d):
		for j in range(ceil(n/d)):
			if i + j*d < n:
				C += A_list[i+j*d] * Bz[i]
			#update Bz[0,1,...,d-1]
			Bz[i] = shift_by_z(Bz[i],f,d)

	return C





###################################################
# 					 SANDBOX					  #
###################################################	

set_random_seed(12345)
SL = 'ROLLO-I-128'

############################################################################
#
# initialize the system parameters
#
############################################################################
# #ROLLO-I setups
# if SL == 'ROLLO-I-128':
#   n = 47
#   m = 79

#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[47] = 1
#   P_list[5] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[79] = 1
#   f_list[9] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-I-192':
#   n = 53
#   m = 89
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[53] = 1
#   P_list[6] = 1
#   P_list[2] = 1
#   P_list[1] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[89] = 1
#   f_list[38] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-I-256': 
#   n = 67
#   m = 113

#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[67] = 1
#   P_list[5] = 1
#   P_list[2] = 1
#   P_list[1] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[113] = 1
#   f_list[9] = 1
#   f_list[0] = 1

# #ROLLO-II setups
# elif SL == 'ROLLO-II-128':
#   n = 149
#   m = 83
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[149] = 1
#   P_list[10] = 1
#   P_list[9] = 1
#   P_list[7] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[83] = 1
#   f_list[7] = 1
#   f_list[4] = 1
#   f_list[2] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-II-192':
#   n = 151
#   m = 107
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[151] = 1
#   P_list[3] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[107] = 1
#   f_list[9] = 1
#   f_list[7] = 1
#   f_list[4] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-II-256':
#   n = 157
#   m = 127
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[157] = 1
#   P_list[6] = 1
#   P_list[5] = 1
#   P_list[2] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[127] = 1
#   f_list[1] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-III-128':
#   n = 47
#   m = 101
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[47] = 1
#   P_list[5] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[101] = 1
#   f_list[7] = 1
#   f_list[6] = 1
#   f_list[1] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-III-192':
#   n = 59
#   m = 107
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[59] = 1
#   P_list[7] = 1
#   P_list[4] = 1
#   P_list[2] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[107] = 1
#   f_list[9] = 1
#   f_list[7] = 1
#   f_list[4] = 1
#   f_list[0] = 1

# elif SL == 'ROLLO-III-256':
#   n = 67
#   m = 131
  
#   P_list = (n+1)*[0] # sparse list for polynomial P
#   P_list[67] = 1
#   P_list[5] = 1
#   P_list[2] = 1
#   P_list[1] = 1
#   P_list[0] = 1

#   f_list = (m+1)*[0] # sparse list for polynomial f
#   f_list[131] = 1
#   f_list[8] = 1
#   f_list[3] = 1
#   f_list[2] = 1
#   f_list[0] = 1

#ROLLO-I setups
if SL == 'ROLLO-I-128':
  n = 83
  m = 67

  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[83] = 1
  P_list[7] = 1
  P_list[4] = 1
  P_list[2] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[67] = 1
  f_list[5] = 1
  f_list[2] = 1
  f_list[1] = 1
  f_list[0] = 1

elif SL == 'ROLLO-I-192':
  n = 97
  m = 79
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[97] = 1
  P_list[6] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[79] = 1
  f_list[9] = 1
  f_list[0] = 1

elif SL == 'ROLLO-I-256': 
  n = 113
  m = 97

  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[113] = 1
  P_list[9] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[97] = 1
  f_list[6] = 1
  f_list[0] = 1

#ROLLO-II setups
elif SL == 'ROLLO-II-128':
  n = 189
  m = 83
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[189] = 1
  P_list[6] = 1
  P_list[5] = 1
  P_list[2] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[83] = 1
  f_list[7] = 1
  f_list[4] = 1
  f_list[2] = 1
  f_list[0] = 1

elif SL == 'ROLLO-II-192':
  n = 193
  m = 97
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[193] = 1
  P_list[15] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[97] = 1
  f_list[6] = 1
  f_list[0] = 1

elif SL == 'ROLLO-II-256':
  n = 211
  m = 97
  
  P_list = (n+1)*[0] # sparse list for polynomial P
  P_list[211] = 1
  P_list[11] = 1
  P_list[10] = 1
  P_list[8] = 1
  P_list[0] = 1

  f_list = (m+1)*[0] # sparse list for polynomial f
  f_list[97] = 1
  f_list[6] = 1
  f_list[0] = 1


#construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
PR.<x> = PolynomialRing(GF(2))
f = PR(f_list)
ffi_elt = GF(2^m, 'x', modulus = f)
PR_F_2m.<z> = PolynomialRing(ffi_elt)

#construct the polynomial ring over GF(2m)[z] based on the ring polynomial P
nonzero_idx = [i for i, e in enumerate(P_list) if e != 0]
P = 0
for i in nonzero_idx:
  P += z^i

ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(P))


A = ffi_vec.random_element()
B = ffi_vec.random_element()

# print ( "A: " + str(ffi_vec_list(A)))
# print ( "B: " + str(ffi_vec_list(B)))
# print ( "A*B: " + str(ffi_vec_list(A*B)))


#multiple digit-by-digit interleaved multiplication	
d = 3
test = True
for i in range(1):
	if digit_lv_inter_mul(A,B,P,d) == A * B:
		test &= True
	else:
		test &= False

if test == True:
	print 'digit level interleaved multiplication is correct!'
else:
	print 'digit level interleaved multiplication is wrong!'

