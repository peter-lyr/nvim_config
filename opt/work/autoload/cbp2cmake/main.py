import os
import sys

if __name__ == "__main__":
    if len(sys.argv) >= 2:
        project_root = sys.argv[1]
        print(project_root)
        with open(os.path.join(project_root, "CMakeLists.txt"), "wb") as ff:
            ff.write(b"cmake_minimum_required(VERSION 3.5)\n")
            ff.write(b"set(PROJECT_NAME proj_name)\n")
            ff.write(b"project(${PROJECT_NAME})\n\n")
