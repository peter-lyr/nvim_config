#include <Windows.h>
#include <ctype.h>
#include <io.h>
#include <libloaderapi.h>
#include <shlobj.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <wincon.h>

char *get_parent_dir_do(const char *path) {
    char *parent_dir = NULL;
    char *last_slash = strrchr(path, '\\');
    if (last_slash != NULL) {
        parent_dir = (char *)malloc(last_slash - path + 1);
        memcpy(parent_dir, path, last_slash - path);
        parent_dir[last_slash - path] = '\0';
    }
    return parent_dir;
}

char *get_parent_dir(const char *path, int level) {
    char *newpath = get_parent_dir_do(path);
    level--;
    for (int i = 0; i < level; i++) {
        newpath = get_parent_dir_do(newpath);
    }
    return newpath;
}

int main(int argc, char *argv[]) {

    char cur_exe_path[MAX_PATH + 1]; // ## C:\nv\zi\nv\te.exe
    GetModuleFileNameA(NULL, cur_exe_path, MAX_PATH);

    char start_here[MAX_PATH + 1];
    if (argc >= 2) {
        strcpy(start_here, argv[1]);
    } else {
        strcpy(start_here, get_parent_dir(cur_exe_path, 1));
    }
    char *nv = get_parent_dir(cur_exe_path, 7);
    char *nvimwin64 = get_parent_dir(cur_exe_path, 6);
    char *pack = get_parent_dir(cur_exe_path, 2);

    char localappdata[256];
    sprintf(localappdata, "%s\\%s", pack, "localappdata");

    char temp[256];
    sprintf(temp, "%s\\%s\\%s", pack, "localappdata", "temp");

    char nvimexe[256];
    sprintf(nvimexe, "%s\\%s", nvimwin64, "bin\\nvim-qt.exe");

    char cmd[2048];
    sprintf(cmd, "set LOCALAPPDATA=%s&& set TEMP=%s&& set INCLUDE=%s\\mingw64\\x86_64-w64-mingw32\\include&& start /d %s /b %s", localappdata, temp, nv, start_here, nvimexe);

    system(cmd);

    return 0;
}
