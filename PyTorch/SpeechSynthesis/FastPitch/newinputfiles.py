

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

def absolute_paths(filepath, newtype):
    open(f"filelists/absolute_paths_{newtype}.txt", 'w')
    newfile = open(f"filelists/absolute_paths_{newtype}.txt", 'a')

    abspath = "/exports/chss/eddie/ppls/groups/lel_hcrc_cstr_students/s1936986_Niamh_Corkey/LJSpeech-1.1/"

    with open(filepath, 'r') as inputfile:
        for line in inputfile:

            if len(line) > 20:
                fileno = line[5:15]
                text = line[40:]
                newline = abspath + f"mels/{fileno}.pt|" + abspath + f"pitch/{fileno}.pt|" + abspath + f"coefs/{fileno}.npy|" + text

                newfile.write(newline)

            else:
                newline = "mels|pitch|coefs|text\n"
                newfile.write(newline)

absolute_paths("filelists/ljs_audio_pitch_text_test.txt", "test")



