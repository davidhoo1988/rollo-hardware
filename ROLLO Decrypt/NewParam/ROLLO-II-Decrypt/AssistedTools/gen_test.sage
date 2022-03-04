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

    SL = 'ROLLO-I-128'

############################################################################
#
#   initialize the system parameters
#
############################################################################
    #ROLLO-I setups
    if SL == 'ROLLO-I-128':
      n = 47
      m = 79

      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[47] = 1
      P_list[5] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[79] = 1
      f_list[9] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-I-192':
      n = 53
      m = 89
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[53] = 1
      P_list[6] = 1
      P_list[2] = 1
      P_list[1] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[89] = 1
      f_list[38] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-I-256': 
      n = 67
      m = 113

      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[67] = 1
      P_list[5] = 1
      P_list[2] = 1
      P_list[1] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[113] = 1
      f_list[9] = 1
      f_list[0] = 1

    #ROLLO-II setups
    elif SL == 'ROLLO-II-128':
      n = 149
      m = 83
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[149] = 1
      P_list[10] = 1
      P_list[9] = 1
      P_list[7] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[83] = 1
      f_list[7] = 1
      f_list[4] = 1
      f_list[2] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-II-192':
      n = 151
      m = 107
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[151] = 1
      P_list[3] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[107] = 1
      f_list[9] = 1
      f_list[7] = 1
      f_list[4] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-II-256':
      n = 157
      m = 127
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[157] = 1
      P_list[6] = 1
      P_list[5] = 1
      P_list[2] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[127] = 1
      f_list[1] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-III-128':
      n = 47
      m = 101
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[47] = 1
      P_list[5] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[101] = 1
      f_list[7] = 1
      f_list[6] = 1
      f_list[1] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-III-192':
      n = 59
      m = 107
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[59] = 1
      P_list[7] = 1
      P_list[4] = 1
      P_list[2] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[107] = 1
      f_list[9] = 1
      f_list[7] = 1
      f_list[4] = 1
      f_list[0] = 1

    elif SL == 'ROLLO-III-256':
      n = 67
      m = 131
      
      P_list = (n+1)*[0] # sparse list for polynomial P
      P_list[67] = 1
      P_list[5] = 1
      P_list[2] = 1
      P_list[1] = 1
      P_list[0] = 1

      f_list = (m+1)*[0] # sparse list for polynomial f
      f_list[131] = 1
      f_list[8] = 1
      f_list[3] = 1
      f_list[2] = 1
      f_list[0] = 1

    else:
      print 'Input Errors'  
      exit()

    k = 2*n
    l = 2*m
    r = 5
    d = 6

    k1 = ceil(1.0*k/d)*d

    MS = MatrixSpace(GF(2), k1, l)

    
    #construct the GF(2m)(e.g, ffi_elt) based on the irreducible polynomial f
    ffi_elt = GF(2^m, 'x', modulus = f_list)

    # generate a matrix S from vector space EF
    E = ffi_vec_set_random_full_rank(ffi_elt, r)
    F = ffi_vec_set_random_full_rank(ffi_elt, d)
    EF = ffi_vec_directsum(E, F)
    ffi_vec_S = ffi_vec_set_random_from_support(EF, n)

    
    S = matrix(GF(2),n,m)
    for i in range(n):
        tmp = ffi_elt(ffi_vec_S[i]).polynomial().list()
        for j in range(len(tmp)):
            S[i,j] = tmp[j]

    ffi_vec_finv = [ffi_elt_set_random(ffi_elt) for i in range(2)]
    finv = matrix(GF(2),2,m)
    for i in range(2):
        tmp = ffi_elt(ffi_vec_finv[i]).polynomial().list()
        for j in range(len(tmp)):
            finv[i,j] = tmp[j]

    S1 = matrix(GF(2),n,m)
    for i in range(n):
        tmp = (ffi_vec_S[i]*ffi_vec_finv[0]).polynomial().list()
        for j in range(len(tmp)):
            S1[i,j] = tmp[j]   

    S2 = matrix(GF(2),n,m)
    for i in range(n):
        tmp = (ffi_vec_S[i]*ffi_vec_finv[1]).polynomial().list()
        for j in range(len(tmp)):
            S2[i,j] = tmp[j]  

    # formulate the target 2n*2m matrix S1S2 from S1 and S2        
    S1S2 = block_matrix([ [S1, S1], [S2, 0] ])
    ZERO = zero_matrix(GF(2), k1-k, l)
    S1S2 = block_matrix([ [S1S2], [ZERO] ]) 



    # write S, finv, S1S2 file - row wise
    # with open("mem_S1S2.txt", "w") as f:
    #   for r in S1S2.rows():
    #     for i in r:
    #       f.write("{0}".format(i))
    #     f.write("\n")
    # f.close()

    with open("mem_S.txt", "w") as f: # each row has 5 lines
        for i in range(ceil(n/5.0)):
            for j in range(5):
                if i*5+j < n:
                    for r in S[i*5+j,:].rows():
                        for bit in r:    
                            f.write("{0}".format(bit))
                else:
                    for bit in [0]*m:
                        f.write("{0}".format(bit))      
            f.write("\n")
    f.close()

    with open("mem_finv.txt", "w") as f:
      for r in finv.rows():
        for i in r:
          f.write("{0}".format(i))
        f.write("\n")
    f.close()
