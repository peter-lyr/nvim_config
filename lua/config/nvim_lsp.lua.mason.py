# put it in mason director and run

import os
import re
import sys

mason = b'C:\\\\Users\\\\l\\\\AppData\\\\Local\\\\nvim-data\\\\mason'
python = b'C:\\\\Program Files\\\\Python38'

_root = sys.argv[1]

for root, dirs, files in os.walk(_root):
  for file in files:
    root = os.path.abspath(root)
    if file in ['activate', 'activate.bat']:
      file = os.path.join(root, file)
      print(file)
      with open(file, 'rb') as f:
        content = f.read()
      res = re.subn(b'VIRTUAL_ENV=".+mason', b'VIRTUAL_ENV="' + mason, content)
      if res[1]:
        with open(file, 'wb') as f:
          f.write(res[0])
      else:
        res = re.subn(b'VIRTUAL_ENV=.+mason', b'VIRTUAL_ENV=' + mason, content)
        if res[1]:
          with open(file, 'wb') as f:
            f.write(res[0])
    elif file == 'pyvenv.cfg':
      file = os.path.join(root, file)
      print(file)
      with open(file, 'rb') as f:
        res = re.subn(b'home = [^\r]+', b'home = ' + python, f.read())
      if res[1]:
        with open(file, 'wb') as f:
          f.write(res[0])
    elif file.split('.')[-1].lower() == 'cmd':
      file = os.path.join(root, file)
      print(file)
      with open(file, 'rb') as f:
        res = re.subn(b'& ".+\\\\mason\\\\packages', b'& "%dp0%\\.\\.\\\\packages', f.read())
      if res[1]:
        with open(file, 'wb') as f:
          f.write(res[0])
