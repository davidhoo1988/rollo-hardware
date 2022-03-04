############################################################################
#
# initialize the system parameters
#
############################################################################
if ObseleteParam == True:
  #ROLLO-I setups
  if SL == 'ROLLO-I-128':
    n = 47
    m = 79
    r = 5
    d = 6

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
    r = 6
    d = 7
    
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
    r = 7
    d = 8

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
    r = 5
    d = 8
    
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
    r = 6
    d = 8
    
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
    r = 7 
    d = 8
    
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
    w = 5
    wr = 6
    
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
    w = 6
    wr = 8
    
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
    w = 7
    wr = 8
    
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
    print ('Iuput Errors')  
    exit()

else:
  if SL == 'ROLLO-I-128':
    n = 83
    m = 67
    r = 7
    d = 8

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
    r = 8
    d = 8
    
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
    r = 9
    d = 9

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
    r = 7
    d = 8
    
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
    r = 8
    d = 8
    
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
    r = 8
    d = 9
    
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

  else:
    print ('Iuput Errors')  
    exit()