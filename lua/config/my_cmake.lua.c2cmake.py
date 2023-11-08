import os
import sys

import shutil


def rep(text):
    return text.replace("\\", "/").lower().rstrip('/')


def rm_build_dirs(project_root):
    rms = ['build', '.cache']
    for root, dirs, _ in os.walk(project_root):
        for r in rms:
            if r in dirs:
                r = rep(os.path.join(root, r))
                if os.path.exists(r):
                    try:
                        print(f"Deleting {r}, ", end = '')
                        shutil.rmtree(r)
                        print(f"Deleted {r}.")
                    except:
                        pass


def is_test_dir(f):
    l = f.split('/')
    for _f in l:
        if not _f:
            return 0
        if _f[0] == '.':
            return 1
        for _I in ['test', 'bak', 'build', '.cache']:
            if _I in _f:
                return 1
    return 0

def check(project_root):
    I = []
    res = os.popen('git ls-files --exclude-standard --ignored --others').read()
    for line in res.splitlines():
        I.append(rep(line))

    D = ['']
    F = []
    for root, _, files in os.walk(project_root):
        for file in files:
            if file.split('.')[-1] in ['c', 'h', 'cpp']:
                f = rep(os.path.join(root, file)).replace(project_root + '/', '').strip('/')
                if f in I:
                    continue
                if is_test_dir(f):
                    continue
                if file.split('.')[-1] in ['c', 'cpp']:
                    F.append(f)
                d = rep(root).replace(project_root, '').strip('/')
                if not is_test_dir(d):
                    d = d.lstrip('/')
                    if d not in D:
                        D.append(d)
    return D, F


if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)

    project_root = rep(sys.argv[1])
    proj_name = os.path.basename(project_root)

    rm_build_dirs(project_root)

    D, F = check(project_root)

    if not F:
        os._exit(3)

    os.system(
        "cd "
        + project_root
        + r' && del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build'
    )

    sels = [project_root]
    print("create CMakeLists.txt at which one:")
    print("1. %s" % sels[0])
    for dir in D:
        dir = rep(os.path.join(project_root, dir))
        if dir not in sels:
            sels.append(dir)
            print("%d. %s" % (len(sels), dir))
        while dir != project_root:
            dir = rep(os.path.dirname(dir))
            if dir not in sels:
                sels.append(dir)
                print("%d. %s" % (len(sels), dir))
    idx = 0
    l = len(sels)
    if l > 1:
        idx = input("> ")
        if idx == 'exit':
            os._exit(4)
        try:
            idx = int(idx)
            if idx < 1:
                idx = 1
            elif idx > l:
                idx = l
            idx -= 1
        except:
            idx = 0
    project_root = sels[idx]

    print("project_root:", project_root)

    D, F = check(project_root)

    print(len(F))

    if len(F) == 0:
        print('no c source files!')
        os._exit(2)

    with open(os.path.join(project_root, "CMakeLists.txt"), "wb") as ff:
        ff.write(b"cmake_minimum_required(VERSION 3.5)\n")
        ff.write((f"set(PROJECT_NAME {proj_name})\n").encode('utf-8'))
        ff.write(b"project(${PROJECT_NAME})\n\n")

        ff.write(b"add_executable(${PROJECT_NAME}\n")
        for f in F:
            f = "              \"${PROJECT_SOURCE_DIR}/" + f + "\"\n"
            ff.write(f.encode('utf-8'))
        ff.write(b"              )\n")

        ff.write(b"target_include_directories(${PROJECT_NAME} PUBLIC\n")
        for d in D:
            if not d:
                d = "                          \"${PROJECT_SOURCE_DIR}" + "\"\n"
            else:
                d = "                          \"${PROJECT_SOURCE_DIR}/" + d + "\"\n"
            ff.write(d.encode('utf-8'))
        ff.write(b"                          )\n")

    # can not be in with block!
    os.system(
        "cd "
        + project_root
        + r' & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..'
    )
