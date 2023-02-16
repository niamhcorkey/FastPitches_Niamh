import numpy as np

tgt = [-0.25, -0.25, -0.25]
tgt = np.array(tgt)
np.save("nslope", tgt)

#coefs = np.load("/Users/user/diss/LJ_Chopped/coefs_norm/LJ007-0053b.npy")
#print(coefs)