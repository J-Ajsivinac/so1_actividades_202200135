# 1

Para determinar cuántos procesos son creados por el programa, se debe analizar el comportamiento del sistema de llamadas `fork()`. La llamada `fork()` crea un nuevo proceso (hijo) que es una copia casi idéntica del proceso original (padre).

1. **Inicio del programa:**
   - Al comenzar, hay **un solo proceso** (el proceso principal o inicial).

   2. **Primera llamada a `fork()` (primer `fork()`):**
      - Después de la primera llamada a `fork()`, se crea un nuevo proceso. Ahora hay **dos procesos**: el original y el hijo creado por la llamada a `fork()`.

      3. **Segunda llamada a `fork()` (segundo `fork()`):**
         - Ambos procesos (el original y el hijo creado en el paso anterior) ejecutan la segunda llamada a `fork()`. Cada uno crea un nuevo proceso, por lo que ahora hay **cuatro procesos**: el proceso original, el hijo del primer `fork()` y dos nuevos hijos, uno para cada proceso.

         4. **Tercera llamada a `fork()` (tercer `fork()`):**
            - Cada uno de los cuatro procesos ejecuta la tercera llamada a `fork()`, creando un nuevo proceso para cada uno. Ahora hay **ocho procesos** en total: los cuatro procesos existentes y cuatro nuevos hijos, uno para cada proceso.

            ### Conteo total de procesos:

            - Empezamos con **1 proceso inicial**.
            - La primera llamada a `fork()` crea **1 proceso nuevo**, sumando un total de **2**.
            - La segunda llamada a `fork()` crea **2 procesos nuevos**, sumando un total de **4**.
            - La tercera llamada a `fork()` crea **4 procesos nuevos**, sumando un total de **8**.

            **Respuesta:** En total se crean **7 nuevos procesos** (8 procesos en total, incluyendo el proceso inicial).

# 2

## Ejecución del programa

```bash
gcc -o zombie zombie.c
./zombie
```

## Verificar el estado del proceso
```bash
ps aux | grep Z
```

**Resultado:**
![alt text](imgs/ps.png)

El estado `z`(zombie) indica que el procesos hijo es un zombie

# 3

## Análisis:

#### 1. Proceso inicial:
            
            
- El programa inicia con un proceso principal.

#### 2. Primer `fork()`:
- El primer `fork()` crea un **nuevo proceso hijo**, por lo que ahora hay dos procesos:
- Proceso padre (inicial).
        
- Proceso hijo (creado por el primer `fork()`).

                                                                                                   
#### 3. Dentro del proceso hijo (bloque `if (pid == 0)`):
                                                                                                    
- El segundo `fork()` crea otro proceso dentro del proceso hijo.
                                                                                                      
- Ahora hay **otro proceso hijo** generado por el segundo `fork()`.

                                                                                                     
 #### 4. Creación del hilo dentro del proceso hijo:
                                                                                    
 - Dentro del primer proceso hijo (donde se ejecuta el segundo `fork()`), también se crea un **hilo**.

#### 5. Tercer `fork()` (fuera del `if`):
                                                            
                                                            
- Después del bloque `if`, el tercer `fork()` se ejecuta tanto en el proceso padre como en los dos procesos hijos creados anteriormente (por el primer y segundo `fork()`).
                            
                            
                            
- Por lo tanto, cada proceso que existía antes del tercer `fork()` generará otro proceso.
- Ahora se duplican los procesos.

 ### Respuestas:

- **Número total de procesos creados**: 6 procesos (incluyendo el inicial).
                                                                                                          - **Número total de hilos creados**: 1 hilo (en el proceso hijo tras el primer fork).

```c
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void* thread_function(void* arg) {
    printf("Thread created!\n");
        return NULL;
        }

        int main() {
            pid_t pid;

                // Primer fork
                    pid = fork();

                        if (pid == 0) { // Proceso hijo
                                // Segundo fork dentro del hijo
                                        fork();

                                                // Crear un hilo en el proceso hijo
                                                        pthread_t thread;
                                                                pthread_create(&thread, NULL, thread_function, NULL);
                                                                        pthread_join(thread, NULL); // Esperar a que el hilo termine
                                                                            }

                                                                                // Tercer fork
                                                                                    fork();

                                                                                        // Solo para que no terminen de inmediato los procesos
                                                                                            sleep(1);

                                                                                                return 0;
                                                                                                }
```