

def add_column(filepath, newtype):
    open(f"filelists/ljs_audio_pitch_coefs_text_{newtype}.txt", 'w')
    newfile = open(f"filelists/ljs_audio_pitch_coefs_text_{newtype}.txt", 'a')

    with open(filepath, 'r') as inputfile:
        for line in inputfile:

            if len(line) > 20:
                fileno = line[5:15]
                newline = line[0:40] + f"coefs/{fileno}.txt|" + line[40:]
                newfile.write(newline)

            else:
                newline = "mels|pitch|coefs|text\n"
                newfile.write(newline)

add_column("filelists/ljs_audio_pitch_text_test.txt", "test")

