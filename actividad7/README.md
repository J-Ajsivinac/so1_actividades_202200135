# Completely Fair Scheduler (CFS)

El Completely Fair Scheduler (CFS) es el algoritmo de planificación predeterminado en Linux desde la versión 2.6.23. Fue diseñado para mejorar el rendimiento en sistemas multiprocesador (SMP) y corregir las deficiencias de su predecesor, el algoritmo O(1), que tenía problemas con los procesos interactivos en sistemas de escritorio.

### Características principales del CFS:

1. **Equidad**: El objetivo principal del CFS es proporcionar una distribución "justa" del tiempo de CPU entre todos los procesos. Esto significa que todos los procesos deben recibir una proporción equitativa de tiempo de CPU en función de su prioridad.
   
2. **Planificación basada en proporciones**: A diferencia de los planificadores tradicionales que dividen el tiempo en intervalos fijos (time slices), el CFS asigna una proporción de tiempo de CPU a cada tarea. Esta proporción se calcula en función del valor *nice* de la tarea, que puede oscilar entre -20 (mayor prioridad) y +19 (menor prioridad). Cuanto más bajo sea el valor nice de una tarea, mayor será la proporción de tiempo de CPU que se le asigna.

3. **Latencia objetivo**: CFS utiliza un concepto llamado "latencia objetivo" (targeted latency), que es el intervalo de tiempo durante el cual todos los procesos en estado de ejecución deberían tener la oportunidad de ejecutar al menos una vez. A medida que el número de tareas activas aumenta, el tiempo disponible para cada tarea se reduce proporcionalmente.

4. **Tiempo de ejecución virtual (vruntime)**: El CFS no asigna prioridades fijas. En su lugar, utiliza una métrica llamada *tiempo de ejecución virtual* o *vruntime*, que es el tiempo que cada tarea ha ejecutado ajustado según su prioridad (*nice*). Las tareas con mayor prioridad (menor nice) incrementan su vruntime más lentamente, mientras que las tareas con menor prioridad lo incrementan más rápido. El planificador elige la tarea con el menor vruntime para ejecutarse a continuación, lo que asegura que las tareas que menos tiempo han ejecutado reciban más tiempo de CPU.

5. **Preemptividad**: Las tareas de mayor prioridad pueden interrumpir (preempt) a las tareas de menor prioridad si se vuelven elegibles para ejecutarse. Por ejemplo, una tarea de I/O puede preemptar a una tarea que está utilizando intensamente la CPU, asegurando que las tareas que dependen de la E/S no se retrasen.

### Estructura de datos y eficiencia:

El CFS organiza las tareas en una estructura de datos eficiente conocida como **árbol rojo-negro** (red-black tree), que es un tipo de árbol binario auto-balanceado. En este árbol, las tareas están ordenadas por su valor vruntime, con las tareas que tienen menor tiempo de ejecución virtual a la izquierda del árbol y las que tienen mayor vruntime a la derecha. Navegar por el árbol para encontrar la tarea con el menor vruntime (la de mayor prioridad) tiene una complejidad de O(log N), donde N es el número de tareas. Sin embargo, para optimizar aún más el rendimiento, el CFS almacena en caché el nodo con el menor valor de vruntime en una variable (*rb_leftmost*), lo que permite acceder rápidamente a la tarea que se debe ejecutar a continuación.

### Ejemplo práctico del funcionamiento del CFS:

Supongamos que hay dos tareas con el mismo valor *nice*, una que es dependiente de la E/S (I/O-bound) y otra que es dependiente de la CPU (CPU-bound). La tarea dependiente de la E/S tiende a ejecutar por cortos periodos de tiempo antes de bloquearse esperando operaciones de E/S, mientras que la tarea dependiente de la CPU ejecuta por intervalos más largos. Debido a que la tarea I/O-bound ejecuta menos tiempo, su vruntime crece más lentamente, lo que hace que tenga más prioridad sobre la tarea CPU-bound. De este modo, cuando la tarea I/O-bound está lista para ejecutarse, puede interrumpir a la tarea CPU-bound y acceder a la CPU primero.

### Planificación en tiempo real:

Además del CFS, Linux implementa clases de planificación en tiempo real basadas en el estándar POSIX, usando las políticas **SCHED_FIFO** y **SCHED_RR**. Las tareas en tiempo real tienen mayor prioridad que las tareas normales y están organizadas en un rango de prioridades estáticas de 0 a 99. Las tareas normales, por su parte, tienen prioridades de 100 a 139. Las tareas con valores numéricos más bajos de prioridad tienen mayor prioridad relativa.

### Beneficios del CFS:

- **Equidad en el uso de la CPU**: Asegura que todos los procesos reciban una porción justa de tiempo de CPU, ajustada según su prioridad.
- **Optimización para tareas interactivas**: Mejora la respuesta de procesos interactivos al permitir que las tareas dependientes de la E/S preempten tareas que consumen más CPU.
- **Escalabilidad**: Es adecuado para sistemas multiprocesador y grandes cargas de trabajo, manteniendo un rendimiento eficiente gracias a su estructura de árbol rojo-negro.

En resumen, el CFS es un algoritmo de planificación flexible y eficiente que garantiza una distribución justa de los recursos de CPU entre las tareas, con una mayor capacidad de respuesta para las tareas interactivas y una estructura de datos optimizada para grandes sistemas.