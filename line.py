import matplotlib.pyplot as plt
import numpy as np
from matplotlib import pylab

file_x = open("x", "r")
file_y = open("y", "r")

x_file = file_x.readlines()
x =[int(e.strip()) for e in x_file]

y_file = file_y.readlines()
y =[int(e.strip()) for e in y_file]

print(x)
print(y)
plt.plot(x, y)
plt.ylim(0,20000000)
plt.title('Runtime')
plt.xlabel('Nr of chars')
plt.ylabel('Time (microseconds)')
plt.show() 