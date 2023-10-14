#include <shlobj.h>
#include <stdio.h>

int main(void) {
    char path[MAX_PATH];
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_DESKTOP                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_INTERNET               , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROGRAMS               , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_CONTROLS               , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PRINTERS               , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_MYDOCUMENTS            , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FAVORITES              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_STARTUP                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_RECENT                 , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_SENDTO                 , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_BITBUCKET              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_STARTMENU              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_DESKTOPDIRECTORY       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_DRIVES                 , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_NETWORK                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_NETHOOD                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FONTS                  , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_TEMPLATES              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_STARTMENU       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_PROGRAMS        , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_STARTUP         , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_DESKTOPDIRECTORY, NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PRINTHOOD              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_LOCAL_APPDATA          , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_ALTSTARTUP             , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_ALTSTARTUP      , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_FAVORITES       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_INTERNET_CACHE         , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COOKIES                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_HISTORY                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_APPDATA         , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_WINDOWS                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_SYSTEM                 , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROGRAM_FILES          , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROFILE                , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_SYSTEMX86              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROGRAM_FILESX86       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROGRAM_FILES_COMMON   , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_PROGRAM_FILES_COMMONX86, NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_TEMPLATES       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_DOCUMENTS       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_ADMINTOOLS      , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_ADMINTOOLS             , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_CONNECTIONS            , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_MUSIC           , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_PICTURES        , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_VIDEO           , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_RESOURCES              , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_RESOURCES_LOCALIZED    , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMMON_OEM_LINKS       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_CDBURN_AREA            , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_COMPUTERSNEARME        , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FLAG_DONT_VERIFY       , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FLAG_DONT_UNEXPAND     , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FLAG_NO_ALIAS          , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FLAG_PER_USER_INIT     , NULL, 0, path))) { printf("%s\n", path); }
    if (SUCCEEDED(SHGetFolderPath(NULL, CSIDL_FLAG_MASK              , NULL, 0, path))) { printf("%s\n", path); }
    return 0;
}
