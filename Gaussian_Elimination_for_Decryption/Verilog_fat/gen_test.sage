#example sage gen_test.sage 4 8 2
import sys

#k*l matrix processed by d*l systolic arrry
# k = int(sys.argv[1])
# l = int(sys.argv[2])
# d = int(sys.argv[3])
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

if __name__ == "__main__":
    n = 149
    m = 83
    k = 2*n
    l = 2*m
    d = 5

    k1 = ceil(1.0*k/d)*d

    MS = MatrixSpace(GF(2), k1, l)

    # generate two matrices A and B from vector space F
    R = GF(2)['x']
    for p in R.polynomials(m):
        if p.is_irreducible():
            print(p)
            break
    ffi_elt = GF(2^m,'x', modulus=p)
 
    E = ffi_vec_set_random_full_rank(ffi_elt, d)
    F = ffi_vec_set_random_full_rank(ffi_elt, d)
    EF = ffi_vec_directsum(E, F)
    ffi_vec_A = ffi_vec_set_random_from_support(F, n)
    ffi_vec_B = ffi_vec_set_random_from_support(EF, n)

    # formulate the target 2n*2m matrix M
    A = matrix(GF(2),n,m)
    for i in range(n):
        tmp = ffi_elt(ffi_vec_A[i]).polynomial().list()
        for j in range(len(tmp)):
            A[i,j] = tmp[j]
    
    B = matrix(GF(2),n,m)
    for i in range(n):
        tmp = ffi_elt(ffi_vec_B[i]).polynomial().list()
        for j in range(len(tmp)):
            B[i,j] = tmp[j]
        
    M = block_matrix([ [A, A], [B, 0] ])
    ZERO = zero_matrix(GF(2), k1-k, l)
    M = block_matrix([ [M], [ZERO] ]) 
    M_rref = M.echelon_form()

    intersect = 0
    for r in M_rref.rows():
        if r[0:M_rref.ncols()/2] == zero_vector(GF(2),M_rref.ncols()/2) and r[M_rref.ncols()/2:M_rref.ncols()] != zero_vector(GF(2),M_rref.ncols()/2):
            intersect = intersect+1
    print intersect


    # while True:
    #     M = MS.random_element()  
    #     for i in range(d,k1):
    #         M[i] = matrix(1,l) #zero padding of the last few rows
    #     M_rref = M.echelon_form()

    #     intersect = 0
    #     for r in M_rref.rows():
    #         if r[0:M_rref.ncols()/2] == zero_vector(GF(2),M_rref.ncols()/2) and r[M_rref.ncols()/2:M_rref.ncols()] != zero_vector(GF(2),M_rref.ncols()/2):
    #             intersect = intersect+1
    #     print intersect
    #     if M_rref.rank() != k and M_rref[0,0:k/2] != matrix(1,k/2) and intersect != 0: # not full-rank, and the first half of the first row is non-zero, and intersection exists
    #         break

    #write data_in file - row wise
    with open("data.in", "w") as f:
      for r in M.rows():
        for i in r:
          f.write("{0}".format(i))
        f.write("\n")

    f.close()

    print "Input matrix:"
    print M
    print ""
