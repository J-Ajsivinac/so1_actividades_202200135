# Actividad 5

### Tabla comparativa de tipos de kernel:

| Característica | Kernel Monolítico      | Microkernel              | Kernel Híbrido         |
| -------------- | ---------------------- | ------------------------ | ---------------------- |
| Estructura     | Todo en espacio kernel | Mínimo en espacio kernel | Combina ambos enfoques |
| Rendimiento    | Alto                   | Potencialmente más bajo  | Intermedio             |
| Flexibilidad   | Baja                   | Alta                     | Intermedia             |
| Estabilidad    | Menor                  | Mayor                    | Intermedia             |
| Complejidad    | Alta                   | Baja                     | Intermedia             |
| Ejemplos       | Linux, BSD             | MINIX, QNX               | Windows NT, macOS      |
| Tamaño         | Grande                 | Pequeño                  | Mediano                |
| Modularidad    | Limitada               | Alta                     | Moderada               |


## User vs Kernel Mode:

1. User Mode (Modo Usuario):
   - Nivel de privilegio más bajo (Ring 3 en arquitectura x86).
   - Las aplicaciones se ejecutan en este modo.
   - Acceso limitado a recursos del sistema.
   - No puede ejecutar instrucciones privilegiadas.
   - Si intenta acceder a recursos protegidos, genera una excepción.
   - Proporciona aislamiento y protección entre procesos.

2. Kernel Mode (Modo Kernel):
   - Nivel de privilegio más alto (Ring 0 en arquitectura x86).
   - El kernel del sistema operativo se ejecuta en este modo.
   - Acceso completo a todos los recursos del sistema.
   - Puede ejecutar cualquier instrucción de CPU y acceder a cualquier dirección de memoria.
   - Responsable de gestionar recursos, programar tareas, y manejar interrupciones.
   - Un error en este modo puede causar un fallo completo del sistema (pantalla azul en Windows).

Cambio entre modos:
- Se realiza mediante llamadas al sistema (system calls).
- El cambio implica un costo en rendimiento debido al cambio de contexto.

## Interrupciones vs Traps:

1. Interrupciones:
   - Tipos:
     a) Interrupciones de hardware: generadas por dispositivos externos.
     b) Interrupciones de software: generadas por programas mediante instrucciones específicas.
   - Características:
     - Asíncronas: pueden ocurrir en cualquier momento.
     - Requieren un cambio inmediato al modo kernel.
     - Se manejan por rutinas de servicio de interrupción (ISR).
     - Ejemplos: llegada de un paquete de red, clic del mouse, finalización de una operación de E/S.
   - Proceso de manejo:
     1. La CPU guarda el estado actual.
     2. Cambia a modo kernel.
     3. Ejecuta la ISR correspondiente.
     4. Restaura el estado y vuelve al modo usuario.

2. Traps (Excepciones):
   - Tipos:
     a) Fallas: errores que pueden ser corregidos.
     b) Traps: reportan después de la ejecución de una instrucción.
     c) Abortos: errores graves que no pueden ser manejados.
   - Características:
     - Síncronas: ocurren en puntos específicos durante la ejecución del programa.
     - Generadas internamente por la CPU.
     - Pueden ser intencionales (como en las llamadas al sistema) o no intencionales (como errores).
   - Ejemplos:
     - División por cero
     - Fallo de página (page fault)
     - Punto de interrupción (breakpoint)
     - Instrucción privilegiada en modo usuario
   - Proceso de manejo:
     1. La CPU detecta la condición de excepción.
     2. Guarda información sobre el estado actual.
     3. Cambia a modo kernel.
     4. Ejecuta el manejador de excepción apropiado.
     5. Dependiendo del tipo, puede continuar la ejecución, terminar el proceso o reiniciar el sistema.

La principal diferencia entre interrupciones y traps es que las interrupciones son eventos externos asíncronos, mientras que los traps son eventos internos síncronos generados por la CPU en respuesta a condiciones específicas durante la ejecución del programa.
