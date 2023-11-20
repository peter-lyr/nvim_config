import os
import sys


def rep(text):
    return text.replace("\\", "/").lower()


def copy(src_root, src_md, tgt_root, tgt_md, _dir, _md):
    if rep(src_root) in rep(src_md):
        src_md = src_md[len(src_root)+1:]
    if rep(tgt_root) in rep(tgt_md):
        tgt_md = tgt_md[len(tgt_root)+1:]
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

    copy(src_root, src_md, tgt_root, tgt_md, _dir, _md)
