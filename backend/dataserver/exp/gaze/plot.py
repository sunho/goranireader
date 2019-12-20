import matplotlib.pyplot as plt
import numpy as np

data = np.loadtxt('data.out', delimiter=',')
plt.figure()
plt.plot(data[:,0])
plt.plot(data[:,1])
plt.plot(data[:,2])
plt.plot(data[:,3])
plt.show()