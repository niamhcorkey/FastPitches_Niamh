
import re

def abs_path(og, type):
    open(f"filelists/abs_eddie_{type}.txt", 'w')
    newfile = open(f"filelists/abs_eddie_{type}.txt", 'a')
    newfile.write("mels|pitch|text\n")
    line_re = re.compile(r'wavs/(.*)\.wav\|(.*)\|(.*)')
    abspath = "/exports/chss/eddie/ppls/groups/lel_hcrc_cstr_students/s1936986_Niamh_Corkey/LJSpeech-1.1/"
    with open(og, 'r') as f:
        for line in f:
            if not line.startswith("m"):
                match = line_re.match(line)
                base = match.group(1)
                pitch = match.group(2)
                text = match.group(3)
                newline = abspath + f"mels/{base}.pt" + "|" + abspath + pitch + "|" +  text +"\n"
                newfile.write(newline)

abs_path("filelists/ljs_audio_pitch_text_val.txt", "val")

