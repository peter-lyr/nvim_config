#include <stdlib.h>
#include <string.h>
#include <stdio.h>

char *get_parent_dir(const char *path) {
    char *parent_dir = NULL;
    char *last_slash = strrchr(path, '\\');
    if (last_slash != NULL) {
        parent_dir = (char *)malloc(last_slash - path + 1);
        memcpy(parent_dir, path, last_slash - path);
        parent_dir[last_slash - path] = '\0';
    }
    return parent_dir;
}

int main(int argc, char *argv[])
{

    // get ps1

    char ps1[256];
    char *config = get_parent_dir(argv[0]);
    sprintf(ps1, "%s\\%s", config, "start-nvim.ps1");

    // get cmd

    char cmd[576];
    sprintf(cmd, "wt pwsh -NoExit -file %s", ps1);

    // run cmd to open nvim.exe in powershell

    system(cmd);

    return 0;
}
