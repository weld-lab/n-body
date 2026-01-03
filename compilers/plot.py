import numpy as np
import matplotlib.pyplot as plt

cast_float = lambda x : float(x)
data_load = lambda d : np.array(list(map(cast_float, d.split()))).reshape(8,2)




# data
flang = data_load("""
1 27.85
2 21.79
3 17.22
4 14.21
5 12.50
6 12.89
7 13.37
8 13.60
""")

gfortran = data_load("""
1 24.954
2 19.428
3 15.266
4 12.500
5 11.410
6 10.668
7 10.568
8 10.660
""")

# plot
plt.plot(flang[:,0], flang[:,1],
         color='#2F6EBA', label='flang',
         lw=1.8, marker='^', ms=9)
plt.plot(gfortran[:,0], gfortran[:,1],
         color='#B02418', label='gfortran',
         lw=1.8, marker='o', ms=8)
plt.xlabel("Nb of threads");plt.ylabel("time (s)")
plt.legend()
plt.tight_layout()
plt.grid()
plt.savefig('compilers.png') 
#plt.show()
