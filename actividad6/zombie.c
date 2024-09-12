#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {
    pid_t pid = fork();

    if (pid > 0) {
        // Proceso padre: duerme para que el hijo se convierta en zombie
        printf("Proceso padre: %d\n", getpid());
        sleep(60);  // Duerme 60 segundos para permitir ver el proceso zombie
    } else if (pid == 0) {
        // Proceso hijo: termina inmediatamente
        printf("Proceso hijo: %d\n", getpid());
        exit(0);
    } else {
        // Error en fork()
        perror("fork");
        return 1;
    }

    return 0;
}
