

def add_column(filepath, newtype):
    newfile = open(f"new{newtype}input.txt", 'w')
    newfile = open(f"new{newtype}input.txt", 'a')

    with open(filepath, 'r') as inputfile:
        for line in inputfile:
            fileno = line[5:15]
            end = line[40:]
            newline = line[0:40] + f"new/{fileno}.txt|" + line[40:]
            newfile.write(newline)


import re

def abs_path(og, type):
    open(f"abs_main_{type}.txt", 'w')
    newfile = open(f"abs_main_{type}.txt", 'a')
    newfile.write("mels|pitch|text\n")
    line_re = re.compile(r'(.*)\|(.*)\|(.*)')
    abspath = "/disk/scratch1/s1936986/LJSpeech-1.1/"
    with open(og, 'r') as f:
        for line in f:
            match = line_re.match(line)
            wav = match.group(1)
            pitch = match.group(2)
            text = match.group(3)
            newline = abspath + wav + "|" + abspath + pitch + "|" +  text +"\n"
            newfile.write(newline)

abs_path("ljs_audio_pitch_text_val.txt", "val")

