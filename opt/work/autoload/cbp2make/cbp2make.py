import os
import re
import sys


def rep(text):
    return text.replace("\\", "/").lower()


def makefile():
    with open("app\\projects\\standard\\Makefile", "rb") as f:
        lines = f.readlines()
    newlines = []
    for line in lines:
        line = line.decode("utf-8").strip()
        if re.findall(r"LIB = ", line):
            matches = re.findall(r" lib(\w+)", line)
            if matches:
                line = "LIB = -l" + " -l".join(matches)
        newlines.append(line)
    with open("app\\projects\\standard\\Makefile.new", "wb") as f:
        f.write("\n".join(newlines).encode("utf-8"))


# os.system("cbp2make.exe -in app.cbp -out Makefile && mingw32-make")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)

    project_root = rep(sys.argv[1])
    print(project_root)
