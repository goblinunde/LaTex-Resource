# lauchli.py

import numpy as np


# Funktion zur Erstellung der Läuchli-Matrix für gegebenes epsilon
def laeuchli_matrix(epsilon):
    L = np.zeros((4, 3))
    L[0, :] = 1
    np.fill_diagonal(L[1:, :], epsilon)
    return L


# Verschiedene Werte für epsilon
epsilons = [1e-3, 1e-10, 1e-20]

for epsilon in epsilons:
    L = laeuchli_matrix(epsilon)

    # Eigenwerte von L^T L
    eigvals = np.linalg.eigvalsh(L.T @ L)[::-1]

    # Quadrate der Singulärwerte von L
    singular_values = np.linalg.svd(L, compute_uv=False)
    singular_values_squared = singular_values**2

    # Output
    print(f"Epsilon: {epsilon}")
    print("Eigenwerte vs. Quadrate der Singulärwerte:")
    for ev, sv in zip(eigvals, singular_values_squared):
        print(f"{ev:.3e} 	 {sv:.3e}")
    print("-")
