import os
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)
    L = []
    with open(sys.argv[1], 'wb') as f:
        for i, runtime in enumerate(sys.argv[2:]):
            for root, dirs, files in os.walk(runtime):
                for dir in dirs:
                    if dir == 'lua':
                        l = os.path.join(root, dir).encode('utf-8')
                        if l not in L:
                            L.append(l)
                            f.write(l + b'\n')
