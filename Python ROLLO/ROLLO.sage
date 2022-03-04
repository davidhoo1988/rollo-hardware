reset()
import hashlib
import sha3 # pip install sha3 package first
import time
load("keccak.py") #self-made python file

keccak.prng_seed( 0xffffffff )


SL = 'ROLLO-II-128'
ObseleteParam = False
load("parameter.py") #ROLLO parameter file
#determine the security parameters used according to the SL option


#construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
ffi_elt = GF(2^m, 'x', modulus = f_list)
PR_F_2m.<z> = PolynomialRing(ffi_elt)

#construct the polynomial ring over GF(2m)[z] based on the ring polynomial P
nonzero_idx = [i for i, e in enumerate(P_list) if e != 0]
P = 0
for i in nonzero_idx:
  P += z^i
f = P # f is the ring polynomial
ffi_vec = QuotientRing(PR_F_2m, PR_F_2m.ideal(f))



def ffi_vec_fprint(ffi_vec_M, filename, filedepth, digit_per_line, digit_size):
#output vector hh to file (depth addresses, each address has m*digit bits data (i.e., digit GF2m elements, each of which is represented in LSB first mode))
    fo = open(filename, "w+")
    m = digit_size
    digit = digit_per_line
    depth = filedepth # memory depth
    for i in range(depth):
        if (i < depth-1) or (i == depth-1 and n%digit == 0):
            for j in range(digit):
                #output each GF(2m) coefficient of A[i] in BIN form bin(ffi_elt.integer_representation())[2:]]
                string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
                fo.write( string.format( ffi_vec_M[i*digit+j].integer_representation() )[::-1] )
            fo.write("\n")

        else:
            for j in range(n%digit):
                string = '{{:0{0}b}}'.format(m) # one GF(2m) coefficient takes up m bits
                #print ( E[i*digit+j].polynomial().list() )
                fo.write( string.format( ffi_vec_M[i*digit+j].integer_representation())[::-1] ) 

    if n%digit != 0:
        for j in range(digit-n%digit):
            fo.write('0'*m)
                             
    fo.close()


def ffi_elt_set_random(GF2m):
    # use as input the object of GF2m
    m = GF2m.degree()
    rng = ''
    for i in range(ceil(m/96)):
        rng += keccak.prng()
    tmp = list( int(s) for s in rng[0:m] )
    return GF2m(tmp)


def ffi_vec_hash(ffi_vec_M): # hash the ffi_vec using SHA-3 variant
    return hashlib.sha3_512( str(ffi_vec_M).encode('utf-8') ).hexdigest()


def ffi_vec_hash_hw(ffi_vec_M, digit): # hash the ffi_vec using SHA-3 variant for hardware implementation
    # return hashlib.sha3_512( str(ffi_vec_M).encode('utf-8') ).hexdigest()
    n = len(ffi_vec_M)
    ffi_elt = ffi_vec_M[0].parent()
    m = ffi_elt.degree()
     
    d = digit # assume digit GF(2m) elements in one memory cell
    if m*d > 576: # ensure m*d <= 576 --> m <= 5
        raise RuntimeError('bit-length overflow in function ffi_vec_hash')  
    byte_str = ''
    for i in range(ceil(1.0*n/d)):
        tmp = []
        for j in range(d):
            if i*d+j < n:               
                tmp += ffi_vec_M[i*d+j].polynomial().list() + [0]*( m-len(ffi_vec_M[i*d+j].polynomial().list()) ) # ensure it has m bits, lsb-mode
                
        # turn ffi_vec_m[*] into binary block string
        bin_str = "".join(str(x) for x in tmp)  
        
        if i != ceil(1.0*n/d)-1: # if not the last row in the memory, padding zero
            bin_str += '0'*(576-len(bin_str))
        else: # if the last row, do post-processing to ensure the length is a multiple of 8
            bin_str += '0'*(8-len(bin_str)%8) if len(bin_str)%8 != 0 else ''

        # turn binary block string(576-bits) to byte-alligned string message(72-bytes)
        for k in range(len(bin_str)/8):
            byte_str += chr( int(bin_str[8*k:8*k+8],2) ) # turn integer value to unicode character
    
        
    return keccak.hexdigest( keccak.sha3_512(byte_str) )


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

def ffi_vec_set_random_full_rank(GF2m, dim):
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
            #r = GF2m.random_element().polynomial().list()
            r = ffi_elt_set_random(GF2m).polynomial().list()
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
    #generate a vector with n GF2m elements with support F (dimF = d)
    ffi_vec = n*[0]
    d = len(F)

    i = 0
    while i < d: #occupy randomly d positions of ffi_vec with coordinates of F
        rnd = keccak.randint(0, n-1)
        if ffi_vec[rnd] == 0:
            ffi_vec[rnd] = F[i]
            i += 1

    for i in range(n): #occupy the remaining n-d positions of ffi_vec with random linear combinations of coordinates of F
        if ffi_vec[i] == 0:
            tmp = 0
            entropy = bin(keccak.randint(0,2^d))[2:].zfill(d)
            for j in range(d):
                if entropy[j] == '1':
                    tmp += F[j]
            ffi_vec[i] = tmp
        
    return ffi_vec  

def ffi_vec_set_random_from_support_hw(F, n, e_status="e1", printer="off"): # for hardware implementation verification only
    #generate a vector with n GF2m elements with support F
    ffi_vec = n*[0]
    d = len(F)

    #the ffi_vec is stored in a block memory with 'digit' ffi_elt at each cell
    digit = 5
    mem_depth = ceil(1.0*n/d)
    mem_depth_blen = floor(log(mem_depth,2))
    i = 0
    while i < 1: #occupy randomly 1 positions of memory with d coordinates of F (i.e. randomly fill consecutive d entries of ffi_vec)
        rnd = keccak.randint_hw(0, 2^d) # get d bits random number and retrieve the random mem addr
        # if printer == "on":
        #     print ("rnd: " + bin(rnd))
        rnd = rnd >> (d-mem_depth_blen)
        # if printer == "on":
        #     print ("occupy_lut: " + bin(rnd))
        if ffi_vec[rnd*digit] == 0:
            for j in range(digit):
                ffi_vec[rnd*digit+j] = F[j]
            i += 1

    #keccak.randint_reset()
    for i in range(mem_depth): #occupy the remaining n/d-1 positions of ffi_vec with random linear combinations of coordinates of F
        if ffi_vec[i*digit] == 0:
            for j in range(d):
                tmp = (F[0].parent())(0)
                entropy = bin(keccak.randint_hw(0,2^d))[2:].zfill(d)
                if e_status == "rollo-ii-e2" and i == 4 and j == 3: #exception in e2 generation of ROLLO-II-128
                    keccak.randint_reset()
                    entropy = bin(keccak.randint_hw(0,2^d))[2:].zfill(d)
                for k in range(d):
                    if entropy[k] == '1':
                        tmp += F[k]
                # if printer == "on" and i == 0:
                #     print (entropy)
                #     print (tmp.polynomial().list()) 

                if i*digit+j < n:
                    ffi_vec[i*digit+j] = tmp

    # if printer == "on":
    #     with open("e.txt", "w") as f:
    #         for i in range(mem_depth):
    #             for j in range(digit):
    #                 if i*digit+j < n:
    #                     f.write("{0:0>79b}".format(ffi_vec[i*digit+j].integer_representation())[::-1])
    #             f.write("\n")
        
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

def ffi_vec_union(ffi_vec_U, ffi_vec_W):
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
        if M1[i,0:m] != zero_matrix(GF(2), 1, m):
            ffi_vec_UW.append( ffi_elt( M1[i,0:m].list() ) ) 

    return ffi_vec_UW

def rank_support_recover(syn, support_F, dim_E, dim_F):
    #start_time = time.clock()
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

        #tmp = ffi_vec_union( ffi_vec_intersection(S_i[i], S_i[i+1]), ffi_vec_intersection(S_i[i+1], S_i[i+2]) )
        #tmp = ffi_vec_union( tmp, ffi_vec_intersection(S_i[i], S_i[i+2]) )
        #tmp = ffi_vec_union( syn, ffi_vec_tensor_mul(support_F, tmp) )
        
        if len(ffi_vec_rref(tmp)) < r*d or len(ffi_vec_rref(tmp)) == r*d:
            syn = tmp 
            break


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
        if len(E) < r or len(E) == r:
            if i != 1:
                print (i)
            break
    #end_time = time.clock()
    #print ("RSR algorithm consumes %f seconds." %(end_time - start_time))

    return E

def rank_support_recover_simple(syn, support_F, dim_E, dim_F):
    d = dim_F  
    r = dim_E

  # Step 1: Expand the vector space of syn to the vector space EF
    # Compute the spaces Si = F[i]^(-1) * S (line 10)   
    S_i = d*[0] # S_0 and S_1
    for i in range(d):
        tmp = n*[0]
        for j in range(n):
            tmp[j] = support_F[i]^(-1) * syn[j]
        S_i[i] = tmp

  # Step 2: Compute intersection of S_0, S_1,...,S_{d-1}
    # for i in range(3):
    #     ffi_vec_fprint(ffi_vec(S_i[i]), "mem_S{j}.txt".format(j=i+1), ceil(n/1), 1, m)      
    tmp = S_i[0]
    for i in range(d-1):
        tmp = ffi_vec_intersection(tmp, S_i[i+1])
        # if i == 5:
        #     print ("S_0 intersecting S_1 gets: %d" %(len(tmp)))
        #     ffi_vec_fprint(tmp, "E.txt", ceil(len(tmp)/1), 1, m)
    return tmp


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

    #generate a random vector space E with dimension of r, and force E to be in the rref form
    E = ffi_vec_set_random_full_rank(ffi_elt, r)    
    E_rref = ffi_vec_rref(E)
    print ("Error Vector Space: ")    
    for i in range(len(E_rref)):
        print (E_rref[i].polynomial().list(), len(E_rref[i].polynomial().list()))


    #generate two random ffi_vec e1, e2 from the support E
    e1 = ffi_vec_set_random_from_support_hw(E,n)
    keccak.randint_reset() #reset rng
    e2 = ffi_vec_set_random_from_support_hw(E,n)
    c = ffi_vec(e1) + ffi_vec(e2)*ffi_vec(h)
    # ffi_vec_fprint(e2, "mem_e2.txt", ceil(n/r), r, m)
    ffi_vec_fprint(h, "mem_h.txt", ceil(n/5), 5, m)
    # ffi_vec_fprint(c, "mem_c.txt", ceil(n/r), r, m)
    # print ("e2: ")    
    # for i in range(len(e2)):
    #     print (e2[i].polynomial().list(), len(e2[i].polynomial().list()))

    # print ("c: ") 
    # c_tmp = c.list()
    # for i in range(len(c_tmp)):
    #     print (c_tmp[i].polynomial().list(), len(c_tmp[i].polynomial().list()))
    return [c.list(), ffi_vec_hash_hw( E_rref, 1 )]

def ROLLO_I_decap(c, sk):

    x = sk[0]
    y = sk[1]
    F = sk[2] 

    #set s = xc mod P  
    s = (ffi_vec(x) * ffi_vec(c)).list()

    #output x,c, and s to memory file
    # ffi_vec_fprint(ffi_vec(x), "mem_x.txt", ceil(n/5), 5, m)
    # ffi_vec_fprint(ffi_vec(c), "mem_c.txt", ceil(n/5), 5, m)
    # ffi_vec_fprint(ffi_vec(s), "mem_s.txt", ceil(n/5), 5, m) 

    f_inv = [0]*d
    for i in range(d):
      f_inv[i] = F[i]^(-1) 
    # ffi_vec_fprint(ffi_vec(f_inv), "mem_finv.txt", d, 1, m) 

    E = rank_support_recover_simple(s, F, r, d)
    # ffi_vec_fprint(ffi_vec(E), "mem_E.txt", r, 1, m) 
    return ffi_vec_hash_hw(E, 1)


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
    E_rref = ffi_vec_rref(E)
    print ("Error Vector Space: ")  
    for i in range(len(E_rref)):
      print (E_rref[i].polynomial().list(), len(E_rref[i].polynomial().list()))

    #generate two random ffi_vec e1, e2 from the support E
    e1 = ffi_vec_set_random_from_support_hw(E,n,printer="off")
    keccak.randint_reset() #reset rng
    e2 = ffi_vec_set_random_from_support_hw(E,n, e_status="rollo-ii-e2", printer="off")

    c = ffi_vec(e1) + ffi_vec(e2)*ffi_vec(h)

    # ffi_vec_fprint(e1, "mem_e1.txt", ceil(n/r), r, m)
    # ffi_vec_fprint(e2, "mem_e2.txt", ceil(n/r), r, m)
    ffi_vec_fprint(h, "mem_h.txt", ceil(n/5), 5, m)
    # ffi_vec_fprint(c.list(), "mem_ct.txt", ceil(n/r), r, m)

    # print ("e1: ")    
    # for i in range(len(e1)):
    #     print (e1[i].polynomial().list(), len(e1[i].polynomial().list()))

    # print ("c: ")   
    # c_tmp = c.list()
    # for i in range(len(c_tmp)):
    #   print (c_tmp[i].polynomial().list(), len(c_tmp[i].polynomial().list()))


    #mask M by Hash(E)
    cipher = ''
    a = ''.join(format(ord(x), 'x') for x in str_M) #hex value of string M
    b = ffi_vec_hash_hw( E_rref, 1 )# hex value of Hash(E) with E of rref
    print ("hash(E_rref):")
    print (b)
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

    ffi_vec_fprint(ffi_vec(x), "mem_x.txt", ceil(n/5), 5, m)
    ffi_vec_fprint(ffi_vec(c), "mem_c.txt", ceil(n/5), 5, m)
    ffi_vec_fprint(ffi_vec(s), "mem_s.txt", ceil(n/5), 5, m) 
    f_inv = [0]*d
    for i in range(d):
      f_inv[i] = F[i]^(-1) 
    ffi_vec_fprint(ffi_vec(f_inv), "mem_finv.txt", d, 1, m) 

    E = rank_support_recover_simple(s, F, r, d)
    ffi_vec_fprint(ffi_vec(E), "mem_E.txt", r, 1, m)    
    #unmask cipher to retrieve the message M
    M = ''
    b = ffi_vec_hash_hw(E, 1)
    for i in range(len(b)):
        y = int(cipher[i], 16) ^^ int(b[i], 16)
        M += '{0:x}'.format(y)

    return bytearray.fromhex(M).decode() # turn hex string to plain ASCII


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
    E_rref = ffi_vec_rref(E)
    # print ("Error Vector Space: ")  
    # for i in range(len(E_rref)):
    #   print (E_rref[i].polynomial().list(), len(E_rref[i].polynomial().list()))

    #generate two random ffi_vec e1, e2 from the support E
    r1 = ffi_vec_set_random_from_support_hw(E,n)
    keccak.randint_reset() #reset rng
    r2 = ffi_vec_set_random_from_support_hw(E,n)
    keccak.randint_reset() #reset rng
    er = ffi_vec_set_random_from_support_hw(E,n)

    sr = ffi_vec(r1) + ffi_vec(r2)*ffi_vec(h)
    se = ffi_vec(er) + ffi_vec(r2)*ffi_vec(s)

    # ffi_vec_fprint(h, "mem_h.txt", ceil(n/wr), wr, m)
    # ffi_vec_fprint(s, "mem_s.txt", ceil(n/wr), wr, m)
    # ffi_vec_fprint(sr.list(), "mem_sr.txt", ceil(n/wr), wr, m)
    # ffi_vec_fprint(se.list(), "mem_se.txt", ceil(n/wr), wr, m)

    print ("hash(E_rref):")
    print (ffi_vec_hash_hw( E_rref, 1 ))

    return [sr.list(), se.list(), ffi_vec_hash_hw( E_rref, 1 )]


def ROLLO_III_decap(c, sk):
    sr = c[0]
    se = c[1]
    x = sk[0]
    y = sk[1]
    F = sk[2]

    #set ec = se - y*sr
    ec = (ffi_vec(se) - ffi_vec(y)*ffi_vec(sr)).list()

    ffi_vec_fprint(ffi_vec(sr), "mem_sr.txt", ceil(n/6), 6, m)
    ffi_vec_fprint(ffi_vec(se), "mem_se.txt", ceil(n/6), 6, m)
    ffi_vec_fprint(ffi_vec(y), "mem_y.txt", ceil(n/6), 6, m)
    ffi_vec_fprint(ffi_vec(ec), "mem_ec.txt", ceil(n/6), 6, m)

    #ffi_vec_fprint(ffi_vec(ffi_vec(y)*ffi_vec(sr)), "tmp.txt", ceil(n/6), 6, m)
    f_inv = [0]*2
    for i in range(2):
      f_inv[i] = F[i]^(-1) 
    ffi_vec_fprint(ffi_vec(f_inv), "mem_finv.txt", 2, 1, m) 

    #recover E from RSR(F, ec, wr)
    E = rank_support_recover_simple(syn = ec, support_F = F, dim_E = wr, dim_F = w)
    ffi_vec_fprint(ffi_vec(E), "mem_E.txt", wr, 1, m)   

    return ffi_vec_hash_hw(E, 1)



# main function

'''string = "a"*1000000
print (keccak.hexdigest(keccak.sha3_512(string)))
print (keccak.state)
a = 0
for i in range(25):
    a = (a << 8)
    a += i
    
keccak.prng_seed(a)
print (keccak.state)
keccak.prng()
print (keccak.state)
keccak.prng()
print (keccak.state)'''

# ROLLO-I run

# keccak.prng_seed( 0xffff0000 ) #reset rng seed

# [pk, sk] = ROLLO_I_keygen()

# failure = 0
# total = 1
# keccak.prng_seed( 0xffffffff ) #reset rng seed

# for i in range(total):    
#   [c, E1] = ROLLO_I_encap(pk)
#   E2 = ROLLO_I_decap(c, sk)
#   if i%1000 == 0:
#       print (i, E1, E2)
#   if E1 == E2:
#       print ("ROLLO-I OK")
#       continue
#   else:
#       print ("ROLLO-I not OK")
#       failure = failure + 1
    
# print ("ROLLO total run %d; fails %d." %(total, failure))


# ROLLO-II run

keccak.prng_seed( 0xffff0000 ) #reset rng seed
[pk, sk] = ROLLO_II_keygen()
keccak.prng_seed( 0xffffffff ) #reset rng seed

failure = 0
total = 1

for i in range(total):
    [c, cipher] = ROLLO_II_encap('hello world!', pk)
    msg = ROLLO_II_decap([c, cipher], sk)
    if 'hello world!' in msg:
        print ("ROLLO-II OK")
    else:
        print ("ROLLO-II not OK")  
        failure += 1

print ("ROLLO total run %d; fails %d." %(total, failure))

# ROLLO-III run

# keccak.prng_seed( 0xffff0000 ) #reset rng seed
# [pk, sk] = ROLLO_III_keygen()
# keccak.prng_seed( 0xffffffff ) #reset rng seed

# [sr, se, E1] = ROLLO_III_encap(pk)
# E2 = ROLLO_III_decap([sr, se], sk)
# if E1 == E2:
#   print ("ROLLO-III OK")
# else:
#   print ("ROLLO-III not OK")





