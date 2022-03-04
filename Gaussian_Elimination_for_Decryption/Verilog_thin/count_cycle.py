import math

n = 97
m = 79
d = 16
Delay = 2

k = 2*n
l = 2*m
k1 = int(math.ceil(1.0*k/d) * d)

cnt = 0;
for i in range(1, int(k1/d)+1):
    cnt = cnt + l+k1+(3-i)*d-1+Delay

cnt = cnt + 1 + (2*l+3*d+Delay-2)
cnt_approx = (2*k*l+k*k)/(2.0*d) + 3*k + 2*l
print (cnt)
print (cnt_approx)
