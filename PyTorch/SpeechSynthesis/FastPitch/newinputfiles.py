import re

def add_column(filepath, newtype):
    open(f"filelists/ljs_audio_pitch_coefs_text_{newtype}.txt", 'w')
    newfile = open(f"filelists/ljs_audio_pitch_coefs_text_{newtype}.txt", 'a')

    with open(filepath, 'r') as inputfile:
        for line in inputfile:

            if len(line) > 20:
                fileno = line[5:15]
                newline = line[0:40] + f"coefs/{fileno}.npy|" + line[40:]
                newfile.write(newline)

            else:
                newline = "mels|pitch|coefs|text\n"
                newfile.write(newline)

#add_column("filelists/ljs_audio_pitch_text_val.txt", "val")

def absolute_paths_norm(filepath, newtype):
    open(f"filelists/cstr_abs_paths_norm_{newtype}.txt", 'w')
    newfile = open(f"filelists/cstr_abs_paths_norm_{newtype}.txt", 'a')

    abspath = "/disk/scratch1/s1936986/LJSpeech-1.1/"

    with open(filepath, 'r') as inputfile:
        for line in inputfile:

            if len(line) > 20:
                fileno = line[5:15]
                text = line[40:]
                newline = abspath + f"mels/{fileno}.pt|" + abspath + f"pitch/{fileno}.pt|" + abspath + f"coefs_norm/{fileno}.npy|" + text

                newfile.write(newline)

            else:
                newline = "mels|pitch|coefs|text\n"
                newfile.write(newline)


def change_coef_path(inputfile, newtype):
    open(f"filelists/phones_cstr_abs_paths_norm_{newtype}.txt", 'w')
    newfile = open(f"filelists/phones_cstr_abs_paths_norm_{newtype}.txt", 'a')

    with open(filepath, 'r') as inputfile:
        for line in inputfile:

            if len(line) > 30:
                newline = re.sub("coefs_norm", "coefs_phones_norm", line)
                newfile.write(newline)

            else:
                newline = "mels|pitch|coefs|text\n"
                newfile.write(newline)

change_coef_path("filelists/ns_cstr_abs_paths_norm_train.txt", "train")
