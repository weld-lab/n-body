import matplotlib.pyplot as plt
import numpy as np

t, ekin, epot = np.loadtxt('e.dat',unpack=True, dtype=np.float64)
plt.plot(t, ekin, color='r', label='ekin')
plt.plot(t, epot, color='b', label='epot')
plt.plot(t, ekin+epot, color='k', label='total')
plt.xlabel('t')
plt.ylabel('E')
plt.legend()
plt.grid()
plt.show()

