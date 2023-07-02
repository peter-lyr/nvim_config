import os
import re
import sys

rootdir = sys.argv[1].replace('\\', '/')

projectName = sys.argv[2].replace('\\', '/')

projFileNames = []
projFileNames_last = []

libDirs = []

patt1 = re.compile('directory="(.+)"')
patt2 = re.compile('filename="(.+?[cS])"')
with open(os.path.join(rootdir, 'CMakeLists.txt'), 'wb') as ff:
  ff.write(b'cmake_minimum_required(VERSION 3.5)\n')
  ff.write(b'set(PROJECT_NAME proj_name)\n')
  ff.write(b'project(${PROJECT_NAME})\n\n')
  d = {}
  for i, j, k in os.walk(rootdir):
    for f in k:
      if f.split('.')[-1] == 'cbp':
        if f == 'app.cbp':
          if projectName != 'projects' and projectName not in i.replace(rootdir, ''):
            continue
          if projectName == 'projects':
            projectName = 'standard'

        ss = os.path.join(i, f).replace(rootdir, '').strip('/').strip('\\')
        with open(os.path.join(i, f), 'rb') as fff:
          content = fff.read().decode('utf-8')
        directories = re.findall(patt1, content)
        directories = list(set([os.path.normpath(os.path.join(i, directory)) for directory in directories]))
        files = re.findall(patt2, content)
        files = [os.path.normpath(os.path.join(i, file)).replace('\\', '/').replace(rootdir, '').strip('/') for file in files]
        d[ss] = [directories, files]
      if f.split('.')[-1] == 'a':
        rel = i.replace(rootdir, '').replace('\\', '/')
        rel_list = rel.split('/')
        if rel_list and rel_list[0] == 'app' and rel not in libDirs:
          libDirs.append(rel)


  new_d = {}
  for key, val in d.items():
    new_key = key.split('/')[-1].split('\\')[-1]
    if new_key not in new_d:
      new_d[new_key] = [[key, val[0], val[1]]]
    else:
      new_d[new_key].append([key, val[0], val[1]])

  for new_key, vals in new_d.items():
    if len(vals) == 1:
      key = vals[0][0]
      directories = vals[0][1]
      files = vals[0][2]
    else:
      prompt = 'select which:\n'
      l = len(vals)
      for i in range(l):
        prompt += '  ' + str(i+1) + ': ' + vals[i][0] + '\n'
      print(prompt)
      idx = 1
      try:
        idx = int(input('input number: '))
      except:
        pass
      idx -= 1
      if idx < 0:
        idx = 0
      if idx >= l:
        idx = l - 1
      key = vals[idx][0]
      directories = vals[idx][1]
      files = vals[idx][2]
    print('make cbp:', key)
    if key.split('.')[0].split('\\')[-1] == 'app':
      projFileNames_last = [key]
      xl = key.split('\\')[0]
      ff.write(("add_executable(${PROJECT_NAME} ${PROJECT_SOURCE_DIR}/%s)\n" % (' ${PROJECT_SOURCE_DIR}/'.join(files))).encode('utf-8'))
      bb = ['target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/%s)' % aa.replace('\\', '/').replace(rootdir, '').strip('\\').strip('/').replace('\\', '/') for aa in directories]
      ff.write(('\n'.join(bb).encode('utf-8')) + b'\n\n')
    elif key.split('.')[0].split('\\')[0] == 'libs':
      projFileNames.append(key)
      xl = '/'.join(key.split('\\')[0:2])
      libname = key.split('\\')[1]
      ff.write(("add_library(%s STATIC ${PROJECT_SOURCE_DIR}/%s)\n" % (libname, ' ${PROJECT_SOURCE_DIR}/'.join(files))).encode('utf-8'))
      bb = ['target_include_directories(%s PUBLIC ${PROJECT_SOURCE_DIR}/%s)' % (libname, aa.replace('\\', '/').replace(rootdir, '').strip('\\').strip('/').replace('\\', '/')) for aa in directories]
      ff.write(('\n'.join(bb).encode('utf-8')) + b'\n')
      ff.write(("target_link_libraries(${PROJECT_NAME} %s)\n\n" % libname).encode('utf-8'))

  bb = ['file(GLOB libraries ${CMAKE_CURRENT_SOURCE_DIR}/%s/*.a)' % libDir for libDir in libDirs]
  ff.write(('\n'.join(bb).encode('utf-8')) + b'\n')
  ff.write(b'target_link_libraries(${PROJECT_NAME} ${libraries})\n')

projFileNames = [fname.replace("/", "\\") for fname in projFileNames + projFileNames_last]
projFileNames = [f'    <Project filename="{fname}" />' for fname in projFileNames]
with open(os.path.join(rootdir, f'{projectName}.workspace'), 'wb') as ff:
  ff.write(b'<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>\n')
  ff.write(b'<CodeBlocks_workspace_file>\n')
  ff.write(b'  <Workspace title="Workspace">\n')
  ff.write(('\n'.join(projFileNames).encode('utf-8')) + b'\n')
  ff.write(b'  </Workspace>\n')
  ff.write(b'</CodeBlocks_workspace_file>\n')

os.system('cd ' + rootdir + r' && del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..')
