import numpy as np
from scipy.sparse import csr_matrix


def hid_hous(AdjMat_rist, nn):
    # Initialization
    k_d = np.zeros((AdjMat_rist.shape[0], nn))
    k_s = np.zeros((AdjMat_rist.shape[1], nn))

    for n in range(1, nn + 1):
        if n == 1:
            k_d[:, n - 1] = np.sum(AdjMat_rist, axis=1)
            k_s[:, n - 1] = np.sum(AdjMat_rist, axis=0)
        else:
            a1 = np.sum(
                AdjMat_rist * np.tile(k_s[:, n - 1].T, (AdjMat_rist.shape[0], 1)),
                axis=1,
            )
            print("a1 shape", a1.shape)
            b1 = 1.0 / k_d[:, 0]
            b1[np.isinf(b1)] = 0
            b1[np.isnan(b1)] = 0
            b1 = csr_matrix(b1)
            print("b1 shape", b1.A.shape)

            a2 = np.sum(
                AdjMat_rist * np.tile(k_d[:, n - 1].T, (AdjMat_rist.shape[1], 1)).T,
                axis=0,
            )
            a2 = a2.T
            print("a2 shape", a2.shape)
            b2 = 1.0 / k_d[:, 0]
            b2[np.isinf(b2)] = 0
            b2[np.isnan(b2)] = 0
            b2 = csr_matrix(b2)
            print("b2 shape", b2.A.shape)

            k_d[:, n - 1] = b1.A * a1  # Convert b1 to array before multiplying
            k_s[:, n - 1] = b2.A * a2  # Convert b2 to array before multiplying

    return k_d, k_s
