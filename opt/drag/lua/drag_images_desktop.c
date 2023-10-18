#include <shlobj.h>
#include <stdio.h>

int main(void) {
    char path[MAX_PATH];
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_DESKTOP, NULL, 0, path))) {
        printf("%s\n", path);
    }
    return 0;
}
