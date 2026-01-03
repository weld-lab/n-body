import numpy as np
from scipy.optimize import curve_fit
import matplotlib.pyplot as plt

data = """10 1.204
342 8.721
674 30.268
1000 65.37
1337 118.98
1673 185.24
2000 272.91"""
form = np.array(
    list(
        map(lambda x : float(x),data.split())
    )
).reshape((7,2))

model = np.vectorize(lambda x,a : a*x**2)
popt, pcov = curve_fit(model, form[:,0], form[:,1], p0=[1.])

plt.plot(form[:,0], form[:,1],
         lw=2, ls="dashed",
         ms=8, color='#B02418', marker='^',
         label='expt')

plt.plot(form[:,0], model(form[:,0], popt[0]),
         lw=1.8, color='#2F6EBA', label=f'model $a x^2$, a = {popt[0]:.0e}')

plt.legend()
plt.xlabel(r'$N_p$')
plt.ylabel(r'time (s)')
plt.tight_layout()
plt.grid()
plt.savefig('complexity.png')
#plt.show()


