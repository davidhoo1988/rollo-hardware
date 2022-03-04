class keccak:
    state = [0]*25

    @staticmethod
    def keccak_f_1600(state):
        KeccakLane = 64
        maxNrRounds = 24
        nrLanes = 25

        # some macro def
        index = lambda x,y: ((x)%5)+5*((y)%5)
        ROL64 = lambda a, offset: ((a << offset) & 0xffffffffffffffff) ^ (a >> (KeccakLane-offset)) if offset != 0 else a #left-cyclic-rotate
        
        # 24 = 12+2*6 KeccakRoundConstant
        KeccakRoundConstants = [0x0000000000000001,\
                                0x0000000000008082,\
                                0x800000000000808a,\
                                0x8000000080008000,\
                                0x000000000000808b,\
                                0x0000000080000001,\
                                0x8000000080008081,\
                                0x8000000000008009,\
                                0x000000000000008a,\
                                0x0000000000000088,\
                                0x0000000080008009,\
                                0x000000008000000a,\
                                0x000000008000808b,\
                                0x800000000000008b,\
                                0x8000000000008089,\
                                0x8000000000008003,\
                                0x8000000000008002,\
                                0x8000000000000080,\
                                0x000000000000800a,\
                                0x800000008000000a,\
                                0x8000000080008081,\
                                0x8000000000008080,\
                                0x0000000080000001,\
                                0x8000000080008008]

        # 25 = 5*5 KeccakRotationOffset
        KeccakRhoOffsets =  [0,  1, 62, 28, 27, 36, 44,  6, 55, 20,  3, 10, 43, 25, 39, 41, 45, 15, 21,  8, 18,  2, 61, 56, 14]

        # start 24 rounds of round-function
        for x in range(5):
            for y in range(5):
                state[index(x, y)] = state[index(x, y)] & 0xffffffffffffffff # ensure each element is 64-bit long
        A = state

        for indexRound in range(maxNrRounds):
            idx = maxNrRounds-1
            # if indexRound == idx:
            #     for x in range(5):
            #         for y in range(5):
            #             print 'A[{x}][{y}]: '.format(x = x, y = y) + hex(A[index(x, y)])
            #     print ''
            #apply theta
            C = [0]*5
            D = [0]*5

            for x in range(5):
                for y in range(5):
                    C[x] ^= A[index(x,y)] 

            for x in range(5):
                D[x] = ROL64(C[(x+1)%5], 1) ^ C[(x+4)%5];

            for x in range(5):
                for y in range(5):
                    A[index(x, y)] ^= D[x];

            # if indexRound == idx:
            #     for x in range(5):
            #         for y in range(5):
            #             print 'C[{x}][{y}]: '.format(x = x, y = y) + hex(A[index(x, y)])
            #     print ''

            #apply rho
            for x in range(5):
                for y in range(5):
                    A[index(x,y)] = ROL64(A[index(x,y)], KeccakRhoOffsets[index(x,y)])

            
            #apply pi
            tempA = [0]*nrLanes;

            for x in range(5):
                for y in range(5):
                    tempA[index(x, y)] = A[index(x, y)]

            for x in range(5):
                for y in range(5):
                    A[index(0*x+1*y, 2*x+3*y)] = tempA[index(x, y)]


            #apply chi
            C = [0]*5;

            for y in range(5):
                for x in range(5):
                    C[x] = A[index(x, y)] ^ ( (2**KeccakLane-1-A[index(x+1, y)]) & A[index(x+2, y)] )
                for x in range(5):
                    A[index(x, y)] = C[x]


            #apply iota
            A[index(0, 0)] ^= KeccakRoundConstants[indexRound];
            # if indexRound == idx:
            #     for x in range(5):
            #         for y in range(5):
            #             print 'G[{x}][{y}]: '.format(x = x, y = y) + hex(A[index(x, y)])
            #     print ''

        return state

    @staticmethod
    def keccak_f_200(state):	
    	KeccakLane = 8
        maxNrRounds = 18
        nrLanes = 25

    	# some macro def
    	index = lambda x,y: ((x)%5)+5*((y)%5)
    	ROL8 = lambda a, offset: ((a << offset) & 0xff) ^ (a >> (KeccakLane-offset)) if offset != 0 else a #left-cyclic-rotate
    	
        # 18 = 12+2*3 KeccakRoundConstant
        KeccakRoundConstants = [0x01,0x82,0x8a,0x00,0x8b,0x01,0x81,0x09,0x8a,0x88,0x09,0x0a,0x8b,0x8b,0x89,0x03,0x02,0x80]

        # 25 = 5*5 KeccakRotationOffset
        KeccakRhoOffsets =  [0, 1, 6, 4, 3, 4, 4, 6, 7, 4, 3, 2, 3, 1, 7, 1, 5, 7, 5, 0, 2, 2, 5, 0, 6]

        # start 18 rounds of round-function
        for x in range(5):
            for y in range(5):
                state[index(x, y)] = state[index(x, y)]%256 # ensure each element is 8-bit long
        A = state

        for indexRound in range(maxNrRounds):
            #apply theta
            C = [0]*5
            D = [0]*5

            for x in range(5):
                for y in range(5):
                    C[x] ^= A[index(x,y)] 

            for x in range(5):
                D[x] = ROL8(C[(x+1)%5], 1) ^ C[(x+4)%5];

            for x in range(5):
                for y in range(5):
                    A[index(x, y)] ^= D[x];

            #apply rho
            for x in range(5):
                for y in range(5):
                    A[index(x,y)] = ROL8(A[index(x,y)], KeccakRhoOffsets[index(x,y)])

            
            #apply pi
            tempA = [0]*nrLanes;

            for x in range(5):
                for y in range(5):
                    tempA[index(x, y)] = A[index(x, y)]

            for x in range(5):
                for y in range(5):
                    A[index(0*x+1*y, 2*x+3*y)] = tempA[index(x, y)]


            #apply chi
            C = [0]*5;

            for y in range(5):
                for x in range(5):
                    C[x] = A[index(x, y)] ^ ( (2**KeccakLane-1-A[index(x+1, y)]) & A[index(x+2, y)] ) # A[x][y] = A[x][y] ^ (~A[x+1][y] & A[x+2][y])
                for x in range(5):
                    A[index(x, y)] = C[x]


            #apply iota
            A[index(0, 0)] ^= KeccakRoundConstants[indexRound];

        return state

    @staticmethod
    def prng_seed(seed): # maximal 96 bits seed
        for i in range(25):
            if i < 12:
                keccak.state[i] = seed & 0xff
                seed = seed >> 8    
            else:
                keccak.state[i] = 0
        return 0  

    @staticmethod
    def prng():
        keccak.state = keccak.keccak_f_200(keccak.state)
        #return the first 12 bytes (i.e. 96 bits) of state as the rng string value
        rng = ''
        for i in range(12):
            rng += (bin(keccak.state[i])[2:]).zfill(8)
        return rng

    @staticmethod
    def randint(a,b): 
        b_blen = len(bin(b))-2
        #return a random int within [a,b]
        
        rng = keccak.prng() # raw 96 bits rnd
        rng1 = int(rng[0:b_blen], 2) # truncated to bit-length of b
        while rng1 < a or rng1 > b:
            rng = keccak.prng()
            rng1 = int(rng[0:b_blen], 2)

        return rng1






    @staticmethod    
    def hexdigest(state):
        digest = ''
        for i in range(len(state)):
            digest += hex(state[i]).lstrip('0x').rstrip('L').zfill(2)
        return digest



    @staticmethod
    def sha3_512(string):
        r = 576
        c = 1024

        keccak.state = [0]*25
        index = lambda x,y: ((x)%5)+5*((y)%5)
        load64 = lambda b: sum((int( hex(ord(b[i])), 16 ) << (8*i)) for i in range(8)) # b[7]b[6]...b[0]
        store64 = lambda a: list((a >> (8*i)) % 256 for i in range(8))   # [a[0],a[1],...,a[7]]    

        # Padding, using 10*1 strategy
        num_bytes = len(string)
        q = 72 - num_bytes%72

        if q == 1:
            string += chr(0x86)
        elif q == 2:
            string += (chr(0x06) + chr(0x80))
        else:    
            string += chr(0x06)
            for i in range(q-2):
                string += chr(0x00)
            string += chr(0x80)
        

        # Absorbing phase
        for i in range(0, len(string), 72):
            tmp = string[i:i+72] + chr(0x00)*128 # 1600-bits (200-bytes) one dimensional data for state
            ########################################
            # print 'input: {x}'.format(x = i/72)
            # print [hex(ord(s)) for s in tmp]
            ########################################

            # convert 1600-bits tmp to 5*5 state[x][y] and added
            for j in range(5):
                for k in range(5):
                    keccak.state[index(j,k)] ^= load64(tmp[8*index(j,k):8*index(j,k)+8]) # XOR 64-bit data each time
            # print [hex(s) for s in keccak.state]
            keccak.state = keccak.keccak_f_1600(keccak.state)
            ########################################
            tmp = [0]*200
            for i in range(5):
                for j in range(5):
                    tmp[8*index(i,j):8*index(i,j)+8] = store64(keccak.state[index(i,j)]) # a list of 8 bytes
            # print 'output:'
            # print [hex(s) for s in tmp[0:64]]
            ########################################

        # Squeezing phase, truncated the first 512 bits (64 bytes) of state
        # covert 3D state to 1D array
        tmp = [0]*200
        for i in range(5):
            for j in range(5):
                tmp[8*index(i,j):8*index(i,j)+8] = store64(keccak.state[index(i,j)]) # a list of 8 bytes

        return tmp[0:64]
