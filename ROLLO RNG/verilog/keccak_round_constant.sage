reset()

PR_F_2m = PolynomialRing(GF(2),'x')
f = x^8 + x^6 + x^5 + x^4 + 1

ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(f))
x = ffi_vec.gen()

l = log(8,2)
ir = 12+2*l
for j in range(l+1):
	print "for the {j}-th bit of rc:".format(j = 2^j-1)
	for i in range(ir):
		tmp = list(x^(j+7*i))
		if tmp[0] == 1:
			print i