import os
import sys

if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)
    L = []
    with open(sys.argv[1], "wb") as f:
        for i, runtime in enumerate(sys.argv[2:]):
            for root, dirs, files in os.walk(runtime):
                for dir in dirs:
                    if dir == "lua":
                        l = os.path.join(root, dir)
                        for _root, _, _files in os.walk(l):
                            for _file in _files:
                                _file = os.path.join(_root, _file)
                                _file = _file.replace('\\', '/')
                                if _file.split('.')[-1].lower() == 'lua':
                                    if _file not in L:
                                        print(_file)
                                        L.append(_file)
                                        f.write(_file.encode('utf-8') + b"\n")
