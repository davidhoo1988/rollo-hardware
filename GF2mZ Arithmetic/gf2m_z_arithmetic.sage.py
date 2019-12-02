
# This file was *autogenerated* from the file gf2m_z_arithmetic.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4); _sage_const_47 = Integer(47); _sage_const_79 = Integer(79)
reset()

def ffi_elt_list(ffi_elt): # transform ffi_elt element to list of binary-type elements.
	tmp_list = [int(i) for i in bin(ffi_elt.integer_representation())[_sage_const_2 :]]
	return tmp_list[::-_sage_const_1 ]

def bin_GF2m(a): # return binary representation of a(x) over GF(2^m), MSB first
	a_list = list(a)
	m = len(a_list)
	tmp = ''
	for i in range(m-_sage_const_1 ,-_sage_const_1 ,-_sage_const_1 ):
		tmp = tmp+str(a_list[i])
	return tmp

def shift_by_z(a, f, digit): # return a(z)*z^digit mod f
	a_list = list(a)
	n = len(a_list)
	f_list = [i for i, e in enumerate(f) if e != _sage_const_0 ] # sparse list for polynomial f
	z = a.parent().gen()
	R = a.parent()

	if len(f_list) == _sage_const_3 : # if f is trinomial
		tmp_list = a_list[n-digit:n]
		a_list = a_list[n-digit:n-_sage_const_1  +_sage_const_1 ] + a_list[_sage_const_0 :n-digit-_sage_const_1  +_sage_const_1 ]
		k = f_list[_sage_const_1 ]
		for j in range(digit):
			a_list[k+j] = a_list[k+j] + tmp_list[j]
		a_z = R(a_list)

	elif len(f_list) == _sage_const_5 : # if f is pentanomial
		tmp_list = a_list[n-digit:n]
		a_list = a_list[n-digit:n-_sage_const_1  +_sage_const_1 ] + a_list[_sage_const_0 :n-digit-_sage_const_1  +_sage_const_1 ]
		for idx in range(_sage_const_1 ,_sage_const_4 ):
			k = f_list[idx]
			for j in range(digit):
				a_list[k+j] = a_list[k+j] + tmp_list[j]
		a_z = R(a_list)
	return a_z


# digit-by-digit MSG-first interleaved multiplication
def bit_lv_inter_mul(A,B,f):
	A_list = list(A)
	n = len(A_list)
	f_list = [i for i, e in enumerate(f) if e != _sage_const_0 ] # sparse list for polynomial f
	z = A.parent().gen()
	R = A.parent()

	C = A_list[n-_sage_const_1 ]*B
	for i in range(n-_sage_const_2 ,-_sage_const_1 ,-_sage_const_1 ):
		if len(f_list) == _sage_const_3 : # if f is trionomial
			C_list = list(C)
			C_list = [C_list[n-_sage_const_1 ]] + C_list[_sage_const_0 :n-_sage_const_1 ]
			k = f_list[_sage_const_1 ]
			C_list[k] = C_list[k] + C_list[_sage_const_0 ]
			Cz = R(C_list)
		elif len(f_list) == _sage_const_5 : # if f is pentanomial
			C_list = list(C)
			C_list = [C_list[n-_sage_const_1 ]] + C_list[_sage_const_0 :n-_sage_const_1 ]
			for j in range(_sage_const_1 ,_sage_const_4 ):
				k = f_list[j]
				C_list[k] = C_list[k] + C_list[_sage_const_0 ]
			Cz = R(C_list)

		C = Cz + A_list[i]*B

	return C


def digit_lv_inter_mul(A,B,f,digit): #multiple digit-by-digit interleaved multiplication, improvement-I proposed in our paper
	ffi_vec = A.parent()
	z = A.parent().gen()
	C = _sage_const_0 
	A_list = list(A)
	d = digit
	Bz = B

	for i in range(ceil(n/d)):
		if i != ceil(n/d)-_sage_const_1 :
			for j in range(d):
				C = C + A_list[i*d+j] * shift_by_z(Bz,f,j)
		else: 
			for j in range(d):
				if i*d + j < n:
					C = C + A_list[i*d+j] * shift_by_z(Bz,f,j)
		#update Bz = Bz * z^d
		Bz = shift_by_z(Bz,f,d)

	return C


def digit_lv_inter_mul2(A,B,f,digit): # digit-by-digit interleaved multiplication, improvement-II proposed in our paper
	ffi_vec = A.parent()
	z = A.parent().gen()
	C = _sage_const_0 
	A_list = list(A)
	d = digit
	n = len(A_list)
	#prepare d copies of the polynomial B(z)
	Bz = d*[_sage_const_0 ]
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

#set_random_seed(12345)


#parameters used in ROLLO-I-128
n = _sage_const_47 
m = _sage_const_79 
k = _sage_const_5 

#generate the ring polynomial P over f2[x]
poly_str = 'x^79+x^9+1'
ffi_elt = GF(_sage_const_2 **_sage_const_79 ,'x', modulus=poly_str)
PR_F_2m = PolynomialRing(ffi_elt, names=('z',)); (z,) = PR_F_2m._first_ngens(1)
f = z**n + z**k + _sage_const_1 
ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(f))


A = ffi_vec.random_element()
B = ffi_vec.random_element()



#multiple digit-by-digit interleaved multiplication	
d = _sage_const_3 
test = True
for i in range(d):
	if digit_lv_inter_mul2(A,B,f,d) == A * B:
		test &= True
	else:
		test &= False

if test == True:
	print 'digit level interleaved multiplication is correct!'
else:
	print 'digit level interleaved multiplication is wrong!'


