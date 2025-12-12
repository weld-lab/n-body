import re
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # nécessaire pour l'import 3D
from matplotlib.animation import FuncAnimation


def read_params(filename="params.f90"):
    Np = None
    dt = None

    # i used chatgpt to generate the regexs ;)
    re_Np = re.compile(r"\bNp\s*=\s*(\d+)", re.IGNORECASE)
    re_dt = re.compile(r"\bdt\s*=\s*([0-9.eE+-]+)", re.IGNORECASE)

    with open(filename, "r") as f:
        for line in f:
            
            line = line.split("!")[0]
            
            m = re_Np.search(line)
            if m:
                Np = int(m.group(1))
                
            m = re_dt.search(line)
            if m:
                dt = float(m.group(1))

    if Np is None or dt is None:
        raise ValueError("Np or dt cannot be found.")

    return Np, dt


# automatically detect parameters
Np, dt = read_params()

# scale limits
SCALE = 1.5

# read file
data = np.fromfile("x.dat", dtype=np.float64)
n_frames = data.size // (Np * 3)
frames = data.reshape((3, Np, n_frames), order="F").transpose(2, 1, 0)

# create figs
fig = plt.figure()
ax = fig.add_subplot(111, projection="3d")

ax.set_facecolor("black")
fig.patch.set_facecolor("black")

ax.grid(False)
ax.set_xticks([])
ax.set_yticks([])
ax.set_zticks([])

ax.xaxis.pane.fill = False
ax.yaxis.pane.fill = False
ax.zaxis.pane.fill = False

ax.xaxis.pane.set_edgecolor("black")
ax.yaxis.pane.set_edgecolor("black")
ax.zaxis.pane.set_edgecolor("black")


# create & set boundaries
xmin, xmax = SCALE*frames[0, :, 0].min(), SCALE*frames[0, :, 0].max()
ymin, ymax = SCALE*frames[0, :, 1].min(), SCALE*frames[0, :, 1].max()
zmin, zmax = SCALE*frames[0, :, 2].min(), SCALE*frames[0, :, 2].max()

ax.set_xlim([xmin, xmax])
ax.set_ylim([ymin, ymax])
ax.set_zlim([zmin, zmax])

dx = xmax - xmin
dy = ymax - ymin

aspect = dx / dy

base_height = 8
fig.set_size_inches(base_height * aspect, base_height)

# animating
glow = ax.scatter(
    frames[0, :, 0],
    frames[0, :, 1],
    frames[0, :, 2],
    s=50,
    c=[(1.0, 0.98, 0.85)],
    alpha=0.15,
    linewidths=0
)

scat = ax.scatter(
    frames[0, :, 0],
    frames[0, :, 1],
    frames[0, :, 2],
    s=12,
    c=[(1.0, 0.98, 0.98)],
    alpha=0.85,
    linewidths=0
)

def update(frame_idx):
    glow._offsets3d = (
        frames[frame_idx, :, 0],
        frames[frame_idx, :, 1],
        frames[frame_idx, :, 2],
    )
    scat._offsets3d = (
        frames[frame_idx, :, 0],
        frames[frame_idx, :, 1],
        frames[frame_idx, :, 2],
    )
    return scat,

ani = FuncAnimation(fig, update, frames=n_frames, interval=10, blit=False)
ani.save("nbody.mp4", writer="ffmpeg", fps=30)
#plt.show()
