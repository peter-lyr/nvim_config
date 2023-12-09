#include <shlobj.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    char path[MAX_PATH];
    if (strcmp(argv[1], "desktop") == 0) {
        if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_DESKTOP, NULL, 0, path))) {
            printf("%s\n", path);
        }
    } else if (strcmp(argv[1], "home") == 0) {
        if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROFILE, NULL, 0, path))) {
            printf("%s\n", path);
        }
    }
    return 0;
}
