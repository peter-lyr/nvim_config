import os
import re
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)
    for root, dirs, files in os.walk(os.path.join(sys.argv[1], 'bin')):
        for file in files:
            file = os.path.join(root, file)
            new = ''
            with open(file, 'rb') as f:
                content = f.read()
                patt = re.compile(r'("[^"]+data\\mason)\\packages')
                res = re.findall(patt, content.decode('utf-8'))
                new, _ = re.subn(patt, r'"%~dp0..\\packages', content.decode('utf-8'))
            with open(file, 'wb') as f:
                f.write(new.encode('utf-8'))
