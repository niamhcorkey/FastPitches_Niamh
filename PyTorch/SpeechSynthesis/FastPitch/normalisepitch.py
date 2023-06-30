

def normalize_pitch(pitch, mean, std):
    mean = 96.97455293816438 #214.72203  # LJSpeech defaults
    std = 24.263669193016945 #65.72038
    zeros = (pitch == 0.0)
    pitch -= mean[:, None]
    pitch /= std[:, None]
    pitch[zeros] = 0.0
    return pitch