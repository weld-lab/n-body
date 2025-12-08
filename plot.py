import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # nécessaire pour l'import 3D
from matplotlib.animation import FuncAnimation

Np = 200
dt = 1e-3

SCALE = 1.5

data = np.fromfile("x.dat", dtype=np.float64)
n_frames = data.size // (Np * 3)
frames = data.reshape((Np, 3, n_frames), order="F").transpose(2, 0, 1)

print(f"{n_frames=}")

fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")

xmin, xmax = SCALE*frames[0, :, 0].min(), SCALE*frames[0, :, 0].max()
ymin, ymax = SCALE*frames[0, :, 1].min(), SCALE*frames[0, :, 1].max()
zmin, zmax = SCALE*frames[0, :, 2].min(), SCALE*frames[0, :, 2].max()

ax.set_xlim([xmin, xmax])
ax.set_ylim([ymin, ymax])
ax.set_zlim([zmin, zmax])

scat = ax.scatter(frames[0, :, 0], frames[0, :, 1], frames[0, :, 2], s=50)


def update(frame_idx):
    scat._offsets3d = (
        frames[frame_idx, :, 0],
        frames[frame_idx, :, 1],
        frames[frame_idx, :, 2],
    )
    ax.set_title(f"t = {frame_idx * dt:.4e} s")
    return scat,

ani = FuncAnimation(fig, update, frames=n_frames, interval=10, blit=False)

plt.show()
