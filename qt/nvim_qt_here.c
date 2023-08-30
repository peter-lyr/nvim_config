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

    char cur_exe_path[MAX_PATH + 1];
    GetModuleFileNameA(NULL, cur_exe_path, MAX_PATH);

    char *pack = get_parent_dir(cur_exe_path, 2);

    char nvim_config[256];
    sprintf(nvim_config, "%s\\%s", pack, "nvim_config");

    char temp[256 + 300];
    sprintf(temp, "%s\\%s", nvim_config, "start-nvim-qt.exe");
    char start_nvim_qt_exe[2309];

    int i, j;
    for (i = 0, j = 0; i < strlen(temp); i++, j++) {
        if (temp[i] == '\\') {
            start_nvim_qt_exe[j++] = '\\';
        }
        start_nvim_qt_exe[j] = temp[i];
    }
    start_nvim_qt_exe[j] = '\0';

    FILE *fp = NULL;

    char nvim_config_reg[2560];
    sprintf(nvim_config_reg, "%s\\%s", nvim_config, "nvim_qt_here.reg");
    printf("nvim_config_reg: %s\n", nvim_config_reg);

    fp = fopen(nvim_config_reg, "w+");

    fprintf(fp,
            "Windows Registry Editor Version 5.00\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Directory\\background\\shell\\nvimqt_here]\n"
            "\"Icon\"=\"start-nvim-qt.exe\"\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Directory\\background\\shell\\nvimqt_here\\command]\n"
            "@=\"%s\"\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Folder\\shell\\nvimqtPrompt]\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Folder\\shell\\nvimqtPrompt\\command]\n"
            "@=\"%s \\\"cd %%1\\\"\"\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Directory\\shell\\nvimqt_here]\n"
            "\"Icon\"=\"start-nvim-qt.exe\"\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Directory\\shell\\nvimqt_here\\command]\n"
            "@=\"%s\"\n"
            "\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\*\\shell\\OpenWithNvimQt]\n"
            "\"Icon\"=\"start-nvim-qt.exe\"\n"
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\*\\shell\\OpenWithNvimQt\\command]\n"
            "@=\"%s \\\"%%1\\\"\"\n",
            start_nvim_qt_exe, start_nvim_qt_exe, start_nvim_qt_exe, start_nvim_qt_exe);

    fclose(fp);

    char rm_nvim_config_reg[2560];
    sprintf(rm_nvim_config_reg, "%s\\%s", nvim_config, "rm_nvim_qt_here.reg");
    printf("rm_nvim_config_reg: %s\n", rm_nvim_config_reg);

    fp = fopen(rm_nvim_config_reg, "w+");

    fprintf(fp,
            "Windows Registry Editor Version 5.00\n"
            "[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Directory\\background\\shell\\nvimqt_here]\n"
            "[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Folder\\shell\\nvimqtPrompt]\n"
            "[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\Directory\\shell\\nvimqt_here]\n"
            "[-HKEY_LOCAL_MACHINE\\SOFTWARE\\Classes\\*\\shell\\OpenWithNvimQt]\n");

    fclose(fp);

    return 0;
}
