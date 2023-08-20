import os
import sys

from matplotlib import path


def rep(text):
    return text.replace("\\", "/").lower().rstrip('/')


if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)

    project_root = rep(sys.argv[1])

    I = []
    res = os.popen('git ls-files --exclude-standard --ignored --others').read()
    for line in res.splitlines():
        I.append(rep(line))

    D = []
    F = []
    for root, dirs, files in os.walk(project_root):
        for file in files:
            if file.split('.')[-1] in ['c', 'h']:
                f = rep(os.path.join(root, file)).replace(project_root + '/', '')
                for i in I:
                    if f in i:
                        break
                else:
                    F.append(f)
                d = rep(root).replace(project_root + '/', '')
                if d not in D:
                    for i in I:
                        if d in i:
                            break
                    else:
                        D.append(d)

    if len(F) == 0:
        print('no c source files!')
        os._exit(2)

    with open(os.path.join(project_root, "CMakeLists.txt"), "wb") as ff:
        ff.write(b"cmake_minimum_required(VERSION 3.5)\n")
        ff.write(b"set(PROJECT_NAME proj_name)\n")
        ff.write(b"project(${PROJECT_NAME})\n\n")
        ff.write(b"add_executable(${PROJECT_NAME}\n")
        for f in F:
            f = "               ${PROJECT_SOURCE_DIR}/" + f.replace(' ', '\\ ') + "\n"
            ff.write(f.encode('utf-8'))
        ff.write(b"              )\n")
        if len(D) > 0:
            ff.write(b"target_include_directories(${PROJECT_NAME} PUBLIC\n")
            for d in D:
                d = "                           ${PROJECT_SOURCE_DIR}/" + d.replace(' ', '\\ ') + "\n"
                ff.write(d.encode('utf-8'))
            ff.write(b"                          )\n")

    # can not be in with block!
    os.system(
        "cd "
        + project_root
        + r' && del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..'
        # + r' && del /s /q build\\CMakeCache.txt & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..'
    )
