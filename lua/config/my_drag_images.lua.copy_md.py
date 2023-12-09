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
# <audio controls name="97s look up"><source src="./.docs/b13147ac.mp3" type="audio/mpeg"></audio>
# }

_dirs = {
  '.images',
  '.docs',
}

_md = '_.md'

patt = ''

def get_src_md_images(src_md):
  L = []
  with open(src_md, 'rb') as f:
    for line in f.readlines():
      for _dir in _dirs:
        patt = "%s/([0-9a-fA-F]{8}\\.\\w+)" % _dir
        patt = re.compile(patt.encode("utf-8"))
        results = re.findall(patt, line)
        if results:
          for result in results:
            L.append([_dir, result.decode('utf-8')])
  return L
# b'![20231026-Thursday-205623](../.images/3606d600.jpg)\r\n' -=-----------
# <audio controls name="97s look up"><source src="./.docs/b13147ac.mp3" type="audio/mpeg"></audio>


def copy(src_root, src_md, tgt_root, tgt_md):
  if rep(src_root) in rep(src_md):
    src_md = src_md[len(src_root)+1:]
  if rep(tgt_root) in rep(tgt_md):
    tgt_md = tgt_md[len(tgt_root)+1:]

  if src_root.lower() == tgt_root.lower():
    os._exit(99)

  images = get_src_md_images(src_root + '/' + src_md)
  for _dir, file in images:
    if not os.path.exists(tgt_root + '\\' + _dir):
      os.mkdir(tgt_root + '\\' + _dir)
    os.system('copy /y ' + src_root + '\\' + _dir + '\\' + file + ' ' + tgt_root + '\\' + _dir + '\\' + file)

  for _dir_ in _dirs:
    with open(os.path.join(src_root, _dir_, _md), 'rb') as f:
      lines = f.readlines()
    append_lines = []
    for _dir, file in images:
      for line in lines:
        if _dir == _dir_ and file in line.decode('utf-8'):
          append_lines.append(line)
    with open(os.path.join(tgt_root, _dir_, _md), 'ab') as f:
      f.writelines(append_lines)

  # print('src_root', src_root)
  # print('src_md', src_md)
  # print('tgt_root', tgt_root)
  # print('tgt_md', tgt_md)
  # print('_dir', _dir)
  # print('_md', _md)


if __name__ == "__main__":
  if len(sys.argv) != 5:
    os._exit(1)
  src_root, src_md, tgt_root, tgt_md, = sys.argv[1:]

  patt = ''
  copy(src_root, src_md, tgt_root, tgt_md)
