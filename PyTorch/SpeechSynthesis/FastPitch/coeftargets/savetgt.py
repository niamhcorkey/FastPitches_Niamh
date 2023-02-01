import numpy as np

tgt = [-3, -3, -3]
tgt = np.array(tgt)
#np.save("n333", tgt)

coefs = np.load("/Users/user/diss/LJ_Chopped/coefs_norm/LJ007-0053b.npy")
print(coefs)