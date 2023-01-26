import csv
import re

def load_filepaths_and_text(fnames, dataset_path=None, has_speakers=False,
                            split="|"):

    #Reads in csv with headers mels|pitch|text|optional-speaker
    #Returns list of dicts

    fpaths_and_text = []
    for fname in fnames:

        with open(fname, encoding='utf-8') as f:
            dict_reader = csv.DictReader(f, delimiter='|', strict=True)
            fpaths_and_text = list(dict_reader)
            #print(fpaths_and_text)

    return fpaths_and_text

fnames = ["ns_cstr_abs_paths_norm_val.txt"]

dicts = load_filepaths_and_text(fnames, dataset_path=None, has_speakers=False, split="|")
print(len(dicts))

def delete_speech_marks(oldfile, output):
    open(output, 'w')
    newfile = open(output, 'a')

    with open(oldfile) as f:
        for line in f:
            newline = re.sub("\"", "", line)
            newfile.write(newline)

#delete_speech_marks("cstr_abs_paths_norm_val.txt", "ns_cstr_abs_paths_norm_val.txt")
