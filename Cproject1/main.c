/*#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <errno.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>

void LS_recur(char* dirName)
{
    DIR* pDIR;
    struct dirent* pDirEnt;
    pDIR = opendir((const char*)dirName);
    if (pDIR == NULL)
    {
        fprintf(stderr, "%s %d: opendir() failed (%s)\n", __FILE__, __LINE__, strerror(errno));
        exit(-1);
    }
    pDirEnt = readdir(pDIR);
    while (pDirEnt != NULL)
    {
        // TODO: Permission using access function
        struct stat st;
        stat(pDirEnt->d_name, &st);


            printf((S_ISDIR(st.st_mode))  ? "d" : "-");
            printf((st.st_mode & S_IRUSR) ? "r" : "-");
            printf((st.st_mode & S_IWUSR) ? "w" : "-");
            printf((st.st_mode & S_IXUSR) ? "x" : "-");
            printf((st.st_mode & S_IRGRP) ? "r" : "-");
            printf((st.st_mode & S_IWGRP) ? "w" : "-");
            printf((st.st_mode & S_IXGRP) ? "x" : "-");
            printf((st.st_mode & S_IROTH) ? "r" : "-");
            printf((st.st_mode & S_IWOTH) ? "w" : "-");
            printf((st.st_mode & S_IXOTH) ? "x" : "-");

        printf(" %s ", pDirEnt->d_name);
        
        printf("%ld\t%s", st.st_size, ctime(&st.st_mtime));
        if (S_ISDIR(st.st_mode) && strcmp(pDirEnt->d_name, ".") && strcmp(pDirEnt->d_name, ".."))
        {
            char newDirName[1000];
            strcpy(newDirName, dirName);
            strcat(newDirName, "/");
            strcat(newDirName, pDirEnt->d_name);
            printf(" # %s # ", newDirName);
            LS_recur(newDirName);
        }
        
        pDirEnt = readdir(pDIR);
    }
    closedir(pDIR);
}

int main(int argc, char* argv[])
{
    LS_recur((char*)"./folder1");
    return 0; 
}
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>
#include <unistd.h>
#include <errno.h>

void RecursiveLS(const char *path, int depth) {
    DIR *pDir = opendir(path);
    if (pDir == NULL)
    {
        fprintf(stderr, "%s %d: opendir() failed (%s)\n", __FILE__, __LINE__, strerror(errno));
        exit(-1);
    }

    struct dirent *entry;
    struct stat st;
    char fullPath[1024];

    while ((entry = readdir(pDir)) != NULL) {
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        snprintf(fullPath, sizeof(fullPath), "%s/%s", path, entry->d_name);
        if (lstat(fullPath, &st) == -1) {
            perror("lstat");
            continue;
        }

    for (int i = 0; i < depth; i++) {
        printf("|   ");
    }

    printf(S_ISDIR(st.st_mode) ? "d" : "-");
    printf((st.st_mode & S_IRUSR) ? "r" : "-");
    printf((st.st_mode & S_IWUSR) ? "w" : "-");
    printf((st.st_mode & S_IXUSR) ? "x" : "-");
    printf((st.st_mode & S_IRGRP) ? "r" : "-");
    printf((st.st_mode & S_IWGRP) ? "w" : "-");
    printf((st.st_mode & S_IXGRP) ? "x" : "-");
    printf((st.st_mode & S_IROTH) ? "r" : "-");
    printf((st.st_mode & S_IWOTH) ? "w" : "-");
    printf((st.st_mode & S_IXOTH) ? "x" : "-");

    struct passwd *pwd = getpwuid(st.st_uid);
    struct group *grp = getgrgid(st.st_gid);
    printf(" %s %s ", pwd->pw_name, grp->gr_name);
    printf("%ld ", st.st_size);

    char timebuf[80];
    strftime(timebuf, sizeof(timebuf), "%b %d %H:%M", localtime(&st.st_mtime));
    printf("%s %s\n", timebuf, entry->d_name);

        if (S_ISDIR(st.st_mode)) {
            RecursiveLS(fullPath, depth + 1);
        }
    }

    closedir(pDir);
}

int main(int argc, char *argv[]) {
    RecursiveLS(".", 0);
    return 0;
}