#include <stdlib.h>
#include <string.h>
#include <stdio.h>

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
    for (int i=0; i<level; i++) {
        newpath = get_parent_dir_do(newpath);
    }
    return newpath;
}

int main(int argc, char *argv[])
{

    // printf("argv[0]: |%s|\n", argv[0]);

    // char *nvimwin64;
    //
    // for (int i=1; i<9; i++) {
    //     nvimwin64 = get_parent_dir(argv[0], i);
    //     printf("%d: |%s|\n", i, nvimwin64);
    // }

    // get config path

    char *config = get_parent_dir(argv[0], 1);
    // printf("config: %s\n", config);

    // get nvimwin64 dir

    char *nvimwin64 = get_parent_dir(argv[0], 6);

    // get localappdata dir

    char *pack = get_parent_dir(argv[0], 2);
    // printf("pack: %s\n", pack);

    char localappdata[256];
    // sprintf(localappdata, "%s\\%s", nvimwin64, "localappdata");
    sprintf(localappdata, "%s\\%s", pack, "localappdata");
    // printf("localappdata: %s\n", localappdata);

    // get nvim-qt.exe

    char nvimqtexe[256];
    sprintf(nvimqtexe, "%s\\%s", nvimwin64, "bin\\nvim-qt.exe");
    // printf("nvimqtexe: %s\n", nvimqtexe);

    // get cmd

    char cmd[576];
    sprintf(cmd, "set LOCALAPPDATA=%s&& start /d %s /b %s", localappdata, config, nvimqtexe);

    // run cmd to open nvim-qt.exe

    system(cmd);

    return 0;
}
