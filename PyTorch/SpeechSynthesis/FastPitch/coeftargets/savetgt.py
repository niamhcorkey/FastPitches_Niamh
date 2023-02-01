import numpy as np

tgt = [-1.47776392, 0.56416835, 0.42459683]
tgt = np.array(tgt)
np.save("real", tgt)

#coefs = np.load("/Users/user/diss/LJ_Chopped/coefs_norm/LJ007-0053b.npy")
#print(coefs)