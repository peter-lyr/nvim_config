import os
import re
import sys


def rep(text):
    return text.replace("\\", "/").lower()


# M.docs_fts = {
#   pdf = '[%s](%s)',
#   mp4 = '<video controls name="%s"><source src="%s" type="video/mp4"></source></video>',
#   mp3 = '<audio controls name="%s"><source src="%s" type="audio/mpeg"></audio>',
#   wav = '<audio controls name="%s"><source src="%s" type="audio/wav"></audio>',
# }

patt = ''

def get_src_md_images(src_md):
    with open(src_md, 'rb') as f:
        for line in f.readlines():
            print(line, '-=-----------')
            patt = "{}"
            patt = re.compile(patt.encode("utf-8"))
            # results = re.findall(patt, line)
# b'![20231026-Thursday-205623](../.images/3606d600.jpg)\r\n' -=-----------
# <audio controls name="97s look up"><source src="./.docs/b13147ac.mp3" type="audio/mpeg"></audio>


def copy(src_root, src_md, tgt_root, tgt_md, _dir, _md):
    if rep(src_root) in rep(src_md):
        src_md = src_md[len(src_root)+1:]
    if rep(tgt_root) in rep(tgt_md):
        tgt_md = tgt_md[len(tgt_root)+1:]

    # images = get_src_md_images(src_root + '/' + src_md)

    # print('src_root', src_root)
    # print('src_md', src_md)
    # print('tgt_root', tgt_root)
    # print('tgt_md', tgt_md)
    # print('_dir', _dir)
    # print('_md', _md)


if __name__ == "__main__":
    if len(sys.argv) != 7:
        os._exit(1)
    src_root, src_md, tgt_root, tgt_md, _dir, _md = sys.argv[1:]

    patt = ''
    copy(src_root, src_md, tgt_root, tgt_md, _dir, _md)
