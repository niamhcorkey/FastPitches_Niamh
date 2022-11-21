

def add_column(filepath, newtype):
    newfile = open(f"new{newtype}input.txt", 'w')
    newfile = open(f"new{newtype}input.txt", 'a')

    with open(filepath, 'r') as inputfile:
        for line in inputfile:
            fileno = line[5:15]
            end = line[40:]
            newline = line[0:40] + f"new/{fileno}.txt|" + line[40:]
            newfile.write(newline)

add_column("filelists/ljs_audio_pitch_text_val.txt", "val")

