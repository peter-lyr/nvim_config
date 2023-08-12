#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

    char *config = get_parent_dir(argv[0], 1);
    char *nv = get_parent_dir(argv[0], 7);
    char *nvimwin64 = get_parent_dir(argv[0], 6);
    char *pack = get_parent_dir(argv[0], 2);

    char localappdata[256];
    sprintf(localappdata, "%s\\%s", pack, "localappdata");

    char temp[256];
    sprintf(temp, "%s\\%s\\%s", pack, "localappdata", "temp");

    char nvimexe[256];
    sprintf(nvimexe, "%s\\%s", nvimwin64, "bin\\nvim-qt.exe");

    char cmd[2048];
    sprintf(
        cmd,
        "set LOCALAPPDATA=%s&& set TEMP=%s&& set "
        "INCLUDE=%s\\mingw64\\x86_64-w64-mingw32\\include&& start /d %s /b %s",
        localappdata, temp, nv, config, nvimexe);

    system(cmd);

    return 0;
}
