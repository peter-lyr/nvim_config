import os
import re
import sys

rootdir = sys.argv[1]

patt1 = re.compile('directory="(.+)"')
patt2 = re.compile('<File name="(.+?)"')
with open(os.path.join(rootdir, 'CMakeLists.txt'), 'wb') as ff:
  ff.write(b'cmake_minimum_required(VERSION 3.5)\n')
  ff.write(b'set(PROJECT_NAME proj_name)\n')
  ff.write(b'project(${PROJECT_NAME})\n\n')
  for i, j, k in os.walk(rootdir):
    for f in k:
      if f.split('.')[-1] == 'cbp':
        with open(os.path.join(i, f), 'rb') as fff:
          content = fff.read().decode('utf-8')
        directories = re.findall(patt1, content)
        directories = [os.path.normpath(os.path.join(i, directory)) for directory in directories]

        ff.write((b"file(GLOB_RECURSE SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.c)\n"))
        ff.write((b"file(GLOB_RECURSE ASM_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/*.S)\n"))
        ff.write(b"add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${ASM_SOURCE_FILES})\n")
        bb = ['target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/%s)' % aa.replace(rootdir, '').strip('\\').strip('/').replace('\\', '/') for aa in directories]
        ff.write(('\n'.join(bb).encode('utf-8')) + b'\n')

os.system('cd ' + rootdir + r' && del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..')
