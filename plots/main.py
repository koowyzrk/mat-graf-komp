import matplotlib as mat
import math

mat.use("TkAgg")
import matplotlib.pyplot as plt
import numpy as np
from mpl_toolkits.mplot3d.art3d import Poly3DCollection


def main():
    render_sequence(lambda ax: (basic_cube(ax), cube1(ax)), "cube1.png")
    render_sequence(lambda ax: (basic_cube(ax), cube2(ax)), "cube2.png")
    render_sequence(lambda ax: (basic_cube(ax), rotate(ax)), "rotate.png")
    render_sequence(lambda ax: (basic_cube(ax), scale(ax)), "scale.png")
    render_sequence(lambda ax: (basic_cube(ax), ortho(ax)), "ortho.png")
    render_sequence(lambda ax: (basic_cube(ax), reflect(ax)), "reflect.png")
    render_sequence(lambda ax: (basic_cube(ax), shear(ax)), "shear.png")
    render_sequence(
        lambda ax: (basic_cube(ax), rotate_around_vector(ax)), "rotate_vec.png"
    )


def cube1(ax):
    draw_cube(ax, p1=(0, 0, 0), p2=(2, 3, 1), color="salmon")


def cube2(ax):
    draw_cube(ax, p1=(1, -2, 0), p2=(3, 1, 1), color="lightgreen")


def render_sequence(func, filename):
    fig = plt.figure(facecolor="none")
    ax = fig.add_subplot(111, projection="3d")
    setup_scene(ax)
    func(ax)
    draw_axes(ax)
    plt.savefig(filename, dpi=300, bbox_inches="tight", transparent=True)
    # plt.show()
    print(f"✅ Saved {filename}")


def setup_scene(ax):
    """Sets up the base grid, axes, and scaling."""
    ax.grid(False)
    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_zticks([])

    # Draw only XY plane grid
    grid_range = np.linspace(-5, 5, 11)
    for x in grid_range:
        ax.plot([x, x], [-5, 5], [0, 0], color="lightgray", linewidth=0.5, zorder=-1)
    for y in grid_range:
        ax.plot([-5, 5], [y, y], [0, 0], color="lightgray", linewidth=0.5, zorder=-1)

    autoscale_equal_3d(ax)


def basic_cube(ax):
    draw_cube(ax, p1=(0, 0, 0), p2=(1, 1, 1), color="black", alpha=0.1)


def draw_cube(ax, p1, p2, color="skyblue", alpha=0.5, zorder=10):
    x1, y1, z1 = p1
    x2, y2, z2 = p2
    vertices = np.array(
        [
            [x1, y1, z1],
            [x2, y1, z1],
            [x2, y2, z1],
            [x1, y2, z1],
            [x1, y1, z2],
            [x2, y1, z2],
            [x2, y2, z2],
            [x1, y2, z2],
        ]
    )

    faces = [
        [vertices[j] for j in [0, 1, 2, 3]],
        [vertices[j] for j in [4, 5, 6, 7]],
        [vertices[j] for j in [0, 1, 5, 4]],
        [vertices[j] for j in [2, 3, 7, 6]],
        [vertices[j] for j in [1, 2, 6, 5]],
        [vertices[j] for j in [4, 7, 3, 0]],
    ]

    ax.add_collection3d(
        Poly3DCollection(
            faces, facecolors=color, edgecolors="k", alpha=alpha, zorder=zorder
        )
    )


def autoscale_equal_3d(ax):
    ax.set_xlim(0, 4)
    ax.set_ylim(0, 4)
    ax.set_zlim(0, 4)
    ax.set_box_aspect([2, 2, 2])
    ax.view_init(elev=20, azim=45)


def draw_axes(ax, length=6, tick_step=1):
    """Rysuje osie X, Y, Z ze strzałkami i numerowaniem."""
    # Strzałki osi
    ax.xaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
    ax.yaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
    ax.zaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
    ax.xaxis.line.set_color((1, 1, 1, 0))
    ax.yaxis.line.set_color((1, 1, 1, 0))
    ax.zaxis.line.set_color((1, 1, 1, 0))
    ax.quiver(
        0, 0, 0, length, 0, 0, color="r", arrow_length_ratio=0.05, zorder=50, alpha=0.5
    )
    ax.quiver(
        0, 0, 0, 0, length, 0, color="g", arrow_length_ratio=0.05, zorder=50, alpha=0.5
    )
    ax.quiver(
        0, 0, 0, 0, 0, length, color="b", arrow_length_ratio=0.05, zorder=50, alpha=0.5
    )

    # Ticki na każdej osi (co tick_step)
    ticks = np.arange(0, length + 0.1, tick_step)
    for t in ticks:
        # X axis tick
        ax.plot([t, t], [0, 0], [0, 0.1], color="r", linewidth=1, zorder=-10)
        ax.text(t, -0.4, 0, f"{t:g}", color="r", fontsize=8)

        # Y axis tick
        ax.plot([0, 0], [t, t], [0, 0.1], color="g", linewidth=1, zorder=-10)
        ax.text(-0.4, t, 0, f"{t:g}", color="g", fontsize=8)

        # Z axis tick
        ax.plot([0, 0], [0, 0], [t, t], color="b", linewidth=1, zorder=-10)
        ax.text(0, 0, t, f"{t:g}", color="b", fontsize=8, ha="left", va="bottom")

    # Etykiety końcowe
    ax.text(length * 0.85, 0.6, 0, "X", color="r", fontsize=14, ha="left", va="bottom")
    ax.text(
        0.6, length * 0.80, 0, "Y", color="g", fontsize=14, ha="center", va="center"
    )
    ax.text(
        -0.5, 0, length * 0.65, "Z", color="b", fontsize=14, ha="center", va="center"
    )


def spherical_to_cartesian(r, theta_deg, phi_deg, deg=True):
    """Konwertuje (r, theta, phi) -> (x,y,z). Theta=azymut, phi=elewacja od osi Z."""
    if deg:
        theta = np.radians(theta_deg)
        phi = np.radians(phi_deg)
    else:
        theta = theta_deg
        phi = phi_deg
    x = r * np.sin(phi) * np.cos(theta)
    y = r * np.sin(phi) * np.sin(theta)
    z = r * np.cos(phi)
    return x, y, z


def draw_three_polar_vectors(
    ax,
    vecs,
    labels=None,
    colors=("C0", "C1", "C2"),
    arrow_length_ratio=0.08,
    alpha=1.0,
    deg=True,
    zorder=20,
):
    """
    Rysuje dokładnie trzy wektory zadane biegunowo.
    vecs: lista/tupla 3 elementów, każdy (r, theta_deg, phi_deg)
    labels: opcjonalna lista 3 etykiet
    colors: kolory strzałek
    deg: jeśli True, wartości theta,phi podawane w stopniach
    """
    assert len(vecs) == 3, "vecs musi zawierać dokładnie 3 wektory"
    if labels is None:
        labels = [None] * 3

    for (r, th, ph), lab, col in zip(vecs, labels, colors):
        x, y, z = spherical_to_cartesian(r, th, ph, deg=deg)
        ax.quiver(
            0,
            0,
            0,
            x,
            y,
            z,
            color=col,
            arrow_length_ratio=arrow_length_ratio,
            alpha=alpha,
            linewidth=1.5,
            zorder=zorder,
            depthshade=False,
        )
        if lab is not None:
            ax.text(
                x * 1.05,
                y * 1.05,
                z * 1.05,
                lab,
                color=col,
                fontsize=10,
                ha="center",
                va="center",
            )


def draw_transformed_cube(ax, vertices, color="skyblue", alpha=0.9, zorder=10):
    faces = [
        [vertices[j] for j in [0, 1, 2, 3]],
        [vertices[j] for j in [4, 5, 6, 7]],
        [vertices[j] for j in [0, 1, 5, 4]],
        [vertices[j] for j in [2, 3, 7, 6]],
        [vertices[j] for j in [1, 2, 6, 5]],
        [vertices[j] for j in [4, 7, 3, 0]],
    ]
    ax.add_collection3d(
        Poly3DCollection(
            faces, facecolors=color, edgecolors="k", alpha=alpha, zorder=zorder
        )
    )


def rotate(ax, angle_deg=45):
    """Obrót sześcianu wokół osi Z o angle_deg stopni."""

    angle = np.radians(angle_deg)
    # Wierzchołki basic_cube
    vertices = np.array(
        [
            [0, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 1, 1],
        ]
    )

    # Macierz rotacji wokół Z
    Rz = np.array(
        [
            [np.cos(angle), -np.sin(angle), 0],
            [np.sin(angle), np.cos(angle), 0],
            [0, 0, 1],
        ]
    )
    rotated_vertices = vertices @ Rz.T

    draw_transformed_cube(ax, rotated_vertices, color="orange")


def scale(ax, sx=2, sy=1, sz=0.5):
    """Skalowanie sześcianu wzdłuż osi X, Y, Z."""
    vertices = np.array(
        [
            [0, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 1, 1],
        ]
    )
    S = np.diag([sx, sy, sz])
    scaled_vertices = vertices @ S.T
    draw_transformed_cube(ax, scaled_vertices, color="purple", alpha=0.6)


def ortho(ax):
    """Projekcja ortograficzna wzdłuż osi Z."""
    vertices = np.array(
        [
            [0, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 1, 1],
        ]
    )
    ortho_vertices = vertices.copy()
    ortho_vertices[:, 2] = 0  # Zerujemy współrzędną Z
    draw_transformed_cube(ax, ortho_vertices, color="cyan", alpha=1.0)


def reflect(ax, plane="xy"):
    """Odbicie względem wskazanej płaszczyzny: 'xy', 'yz', 'xz'."""
    vertices = np.array(
        [
            [0, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 1, 1],
        ]
    )
    if plane == "xy":
        R = np.diag([1, 1, -1])
    elif plane == "yz":
        R = np.diag([-1, 1, 1])
    elif plane == "xz":
        R = np.diag([1, -1, 1])
    else:
        raise ValueError("Plane must be 'xy', 'yz', or 'xz'")
    reflected_vertices = vertices @ R.T
    draw_transformed_cube(ax, reflected_vertices, color="magenta")


def shear(ax, shx=0.5, shy=0.3):
    """Ścinanie sześcianu wzdłuż osi X i Y."""
    vertices = np.array(
        [
            [0, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 1, 1],
        ]
    )
    Sh = np.array([[1, shx, 0], [shy, 1, 0], [0, 0, 1]])
    sheared_vertices = vertices @ Sh.T
    draw_transformed_cube(ax, sheared_vertices, color="lime")


def rotate_around_vector(
    ax, axis=(0, math.sqrt(2) / 2, math.sqrt(2) / 2), angle_deg=90
):
    """Obrót sześcianu wokół dowolnego wektora w przestrzeni."""
    axis = np.array(axis, dtype=float)
    axis /= np.linalg.norm(axis)  # normalizacja osi
    ux, uy, uz = axis
    angle = np.radians(angle_deg)

    # Macierz obrotu Rodriguesa
    c = np.cos(angle)
    s = np.sin(angle)
    R = np.array(
        [
            [
                c + ux**2 * (1 - c),
                ux * uy * (1 - c) - uz * s,
                ux * uz * (1 - c) + uy * s,
            ],
            [
                uy * ux * (1 - c) + uz * s,
                c + uy**2 * (1 - c),
                uy * uz * (1 - c) - ux * s,
            ],
            [
                uz * ux * (1 - c) - uy * s,
                uz * uy * (1 - c) + ux * s,
                c + uz**2 * (1 - c),
            ],
        ]
    )

    # Wierzchołki jednostkowego sześcianu
    vertices = np.array(
        [
            [0, 0, 0],
            [1, 0, 0],
            [1, 1, 0],
            [0, 1, 0],
            [0, 0, 1],
            [1, 0, 1],
            [1, 1, 1],
            [0, 1, 1],
        ]
    )
    rotated_vertices = vertices @ R.T

    # Rysujemy obrócony sześcian
    draw_transformed_cube(ax, rotated_vertices, color="gold", alpha=0.9)

    # Dla kontekstu – wektor osi obrotu
    ax.quiver(
        0,
        0,
        0,
        axis[0] * 4,
        axis[1] * 4,
        axis[2] * 4,
        color="black",
        linewidth=2,
        arrow_length_ratio=0.1,
    )
    ax.text(
        axis[0] * 2.2, axis[1] * 2.2, axis[2] * 1.8, "axis", color="black", fontsize=12
    )


if __name__ == "__main__":
    main()
