import os
import sys

if __name__ == "__main__":
  if len(sys.argv) == 2:
    txt = sys.argv[1]
    if os.path.exists(txt) and os.path.isfile(txt):
      with open(txt, 'wb') as f:
        cnt = 0
        for i in range(1, 27):
          driver = chr(64 + i) + ':/'
          if os.path.exists(driver):
            for root, dirs, files in os.walk(driver):
              for dir in dirs:
                dir = os.path.join(root, dir)
                if dir[-4:] == '.git' and '$recycle.bin' not in dir.lower():
                  dir = dir[:-4].replace('\\', '/')
                  f.write(dir.encode('utf-8') + b'\n')
                  cnt += 1
                  print(cnt, dir)
      print('Done!')
