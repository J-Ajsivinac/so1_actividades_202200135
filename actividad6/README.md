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

