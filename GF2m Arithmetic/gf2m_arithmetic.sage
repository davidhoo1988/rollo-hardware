reset()

def bin_GF2m(a): # return binary representation of a(x) over GF(2^m), MSB first
	a_list = list(a)
	m = len(a_list)
	tmp = ''
	for i in range(m-1,-1,-1):
		tmp = tmp+str(a_list[i])
	return tmp

def bin_GF2m_lsb(a): # return binary representation of a(x) over GF(2^m), LSB first
	a_list = list(a)
	m = len(a_list)
	tmp = ''
	for i in range(0,m,1):
		tmp = tmp+str(a_list[i])
	return tmp

def shift_by_x(a, f, digit): # return a(x)*x^digit mod f
	a_list = list(a)
	m = len(a_list)
	f_list = [i for i, e in enumerate(f) if e != 0] # sparse list for polynomial f
	x = a.parent().gen()
	R = a.parent()

	if len(f_list) == 3: # if f is trinomial
		tmp_list = a_list[m-digit:m]
		a_list = a_list[m-digit:m-1 +1] + a_list[0:m-digit-1 +1]
		k = f_list[1]
		for j in range(digit):
			a_list[k+j] = a_list[k+j] + tmp_list[j]
		a_x = R(a_list)

	elif len(f_list) == 5: # if f is pentanomial
		tmp_list = a_list[m-digit:m]
		a_list = a_list[m-digit:m-1 +1] + a_list[0:m-digit-1 +1]
		for idx in range(1,4):
			k = f_list[idx]
			for j in range(digit):
				a_list[k+j] = a_list[k+j] + tmp_list[j]
		a_x = R(a_list)
	return a_x

# bit-level MSG-first interleaved multiplication
def bit_lv_inter_mul(a,b,f):
	a_list = list(a)
	m = len(a_list)
	f_list = [i for i, e in enumerate(f) if e != 0] # sparse list for polynomial f
	x = a.parent().gen()
	R = a.parent()

	c = a_list[m-1]*b

	for i in range(m-2,-1,-1):
		if len(f_list) == 3: # if f is trionomial
			c_list = list(c)
			c_list = [c_list[m-1]] + c_list[0:m-1]
			k = f_list[1]
			c_list[k] = c_list[k] + c_list[0]
			cx = R(c_list)
		elif len(f_list) == 5: # if f is pentanomial
			c_list = list(c)
			c_list = [c_list[m-1]] + c_list[0:m-1]
			for j in range(1,4):
				k = f_list[j]
				c_list[k] = c_list[k] + c_list[0]
			cx = R(c_list)

		c = cx + a_list[i]*b
		# print (str(i) + ':' + bin_GF2m(c))
	return c


def digit_lv_inter_mul(a,b,f,digit):
	a_list = list(a)
	m = len(a_list)
	f_list = [i for i, e in enumerate(f) if e != 0] # sparse list for polynomial f
	x = a.parent().gen()
	R = a.parent()

	blk_num = ceil(1.0*m/digit)
	a_list_digit = [] # digit fraction of polynomial a

	for i in range(digit):
		if (blk_num-1)*digit + i > m-1:
			a_list_digit.append(0)
		else:
			a_list_digit.append(a_list[(blk_num-1)*digit + i])
	
	c = R(a_list_digit)*b	# the heading digit fraction of polynomial a, padding '0' to its MSB
	# print ('c:' + bin_GF2m(c))
	for i in range(blk_num-2,-1,-1):
		c_xd = shift_by_x(c,f,digit)
		# print ('cx:' + bin_GF2m(c_xd))
		a_list_digit = a_list[i*digit:i*digit+digit-1 +1]
		c = a_list_digit[0]*b
		for j in range(1,digit):
			c = c + a_list_digit[j]*shift_by_x(b,f,j)	
		c = c + c_xd
		# print (str(i) + 'bx:' + bin_GF2m(c))
	return c






###################################################
# 					 SANDBOX					  #
###################################################	

set_random_seed(12345)


#specify parameters used in ROLLO
PARA = 'ROLLO-I-128'



P.<x> = GF(2)[]
if PARA == "ROLLO-I-128":
	m = 67
	f = x^m + x^5 + x^2 + x + 1	
elif PARA == "ROLLO-I-192":
	m = 79
	f = x^m + x^9 + 1
elif PARA == "ROLLO-I-256":
	m = 97
	f = x^m + x^6 + 1	
elif PARA == "ROLLO-II-128":
	m = 83
	f = x^m + x^7 + x^4 + x^2 + 1
elif PARA == "ROLLO-II-192":
	m = 97
	f = x^m + x^6 + 1	
elif PARA == "ROLLO-II-256":
	m = 97
	f = x^m + x^6 + 1		


R = QuotientRing(P, P.ideal(f))

for iter in range(3):
	a = R.random_element() # 55710511636250014552
	b = R.random_element() # 101899833275179779702

	a_replist = []
	string = '{{:0{0}b}}'.format(m)
	for i in string.format(55710511636250014552)[::-1]:
		a_replist = a_replist + [i]
	a = R(a_replist)

	b_replist = []
	string = '{{:0{0}b}}'.format(m)
	for i in string.format(101899833275179779702)[::-1]:
		b_replist = b_replist + [i]
	b = R(b_replist)

	if bit_lv_inter_mul(a,b,f) == a*b:
		print ('bit level interleaved multiplication is correct!')
	else:
		print ('bit level interleaved multiplication is wrong!')

	test = True
	d = floor(m/2)
	for i in range(1,9):
		if digit_lv_inter_mul(a,b,f,i) == a*b:
			test = test & True
		else:
			test = test & False	

	if test == True:
		print ('digit level interleaved multiplication is correct!')
	else:
		print ('digit level interleaved multiplication is wrong!')

	print (bin_GF2m_lsb(a)) 
	print (bin_GF2m_lsb(b))
	print (bin_GF2m_lsb(a*b))
	print ('\n\n')

