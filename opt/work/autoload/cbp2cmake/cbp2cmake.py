import os
import re
import sys


def rep(text):
    return text.replace("\\", "/").lower()


def get_libs_a_dirs(project_root):
    lib_a_files = []
    for root, _, files in os.walk(project_root):
        for file in files:
            if file.endswith(".a"):
                dir = os.path.dirname(
                    rep(os.path.join(root, file))
                    .replace("\\", "/")
                    .replace(project_root, "")
                    .strip("/")
                )
                if dir not in lib_a_files:
                    lib_a_files.append(dir)
    return lib_a_files


def get_executable_cbp(project_root):
    cbp_files = []
    for root, _, files in os.walk(project_root):
        for file in files:
            if file.endswith(".cbp"):
                cbp_files.append(rep(os.path.join(root, file)))
    executable_cbp = ""
    if len(cbp_files) == 1:
        executable_cbp = cbp_files[0]
    elif len(cbp_files) > 1:
        for cbp_file in cbp_files:
            if os.path.basename(cbp_file) in ["app.cbp"]:
                executable_cbp = cbp_file
                break
        else:
            res = input(
                "Type number to choose one of cbp as executable\n"
                + "\n".join([str(i + 1) + ". " + v for i, v in enumerate(cbp_files)])
                + "\n"
                ">> "
            )
            try:
                num = int(res)
                if num in [i + 1 for i, _ in enumerate(cbp_files)]:
                    executable_cbp = cbp_files[num - 1]
            except Exception as e:
                print(e)
    return executable_cbp, cbp_files


def get_files_and_dirs(project_root, executable_cbp, executable_cbp_dir):
    patt1 = re.compile('directory="(.+)"')
    patt2 = re.compile('filename="(.+?[cS])"')
    with open(executable_cbp, "rb") as fff:
        content = fff.read().decode("utf-8")
    directories = []
    files = []
    for directory in re.findall(patt1, content):
        directory = (
            os.path.normpath(os.path.join(executable_cbp_dir, directory))
            .replace("\\", "/")
            .replace(project_root, "")
            .strip("/")
        )
        if directory not in directories:
            directories.append(directory)
    for file in re.findall(patt2, content):
        file = (
            os.path.normpath(os.path.join(executable_cbp_dir, file))
            .replace("\\", "/")
            .replace(project_root, "")
            .strip("/")
        )
        if file not in files:
            files.append(file)
    return files, directories


if __name__ == "__main__":
    if len(sys.argv) < 2:
        os._exit(1)

    project_root = rep(sys.argv[1])

    executable_cbp, cbp_files = get_executable_cbp(project_root)
    executable_cbp_dir = os.path.dirname(executable_cbp)

    if executable_cbp:
        executable_files, executable_dirs = get_files_and_dirs(
            project_root, executable_cbp, executable_cbp_dir
        )
        print('project_root:', project_root)
        print(len(executable_files), "files,", len(executable_dirs), "dirs")
        print("executable_cbp:", executable_cbp)
        with open(os.path.join(project_root, "CMakeLists.txt"), "wb") as ff:
            ff.write(b"cmake_minimum_required(VERSION 3.5)\n")
            ff.write(b"set(PROJECT_NAME proj_name)\n")
            ff.write(b"project(${PROJECT_NAME})\n\n")

            # executable_cbp
            ff.write(
                (
                    "add_executable(${PROJECT_NAME}\n               ${PROJECT_SOURCE_DIR}/%s\n              )\n"
                    % ("\n               ${PROJECT_SOURCE_DIR}/".join(executable_files))
                ).encode("utf-8")
            )
            dirs = [
                "target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/%s)"
                % dir.replace("\\", "/")
                .replace(project_root, "")
                .strip("\\")
                .strip("/")
                .replace("\\", "/")
                for dir in executable_dirs
            ]
            ff.write(("\n".join(dirs).encode("utf-8")) + b"\n\n")

            # other_cbp
            for other_cbp_file in cbp_files:
                if other_cbp_file == executable_cbp:
                    continue
                other_cbp_dir = os.path.dirname(other_cbp_file)

                other_files, other_dirs = get_files_and_dirs(
                    project_root, other_cbp_file, other_cbp_dir
                )
                ff.write(
                    (
                        "add_library(%s STATIC\n            ${PROJECT_SOURCE_DIR}/%s)\n"
                        % (
                            os.path.basename(other_cbp_dir),
                            "\n            ${PROJECT_SOURCE_DIR}/".join(other_files),
                        )
                    ).encode("utf-8")
                )
                dirs = [
                    "target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/%s)"
                    % dir.replace("\\", "/")
                    .replace(project_root, "")
                    .strip("\\")
                    .strip("/")
                    .replace("\\", "/")
                    for dir in other_dirs
                ]
                ff.write(("\n".join(dirs).encode("utf-8")) + b"\n\n")

            # libs
            libs = [
                "file(GLOB libraries ${CMAKE_CURRENT_SOURCE_DIR}/%s/*.a)" % libdir
                for libdir in get_libs_a_dirs(project_root)
            ]
            ff.write(("\n".join(libs).encode("utf-8")) + b"\n")
            ff.write(b"target_link_libraries(${PROJECT_NAME} ${libraries})\n")

        # can not be in with block!
        os.system(
            "cd "
            + project_root
            # + r' && del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..'
            + r' && del /s /q build\\CMakeCache.txt & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..'
        )
