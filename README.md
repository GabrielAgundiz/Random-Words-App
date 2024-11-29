# Random-Words-App
<p>El programa presentado es una aplicación Flutter diseñada para generar palabras
 aleatorias y permitir al usuario administrar una lista de palabras favoritas. Utiliza
 paquetes externos como english_words para la generación de palabras aleatorias y
 provider para la gestión del estado global de la aplicación. La arquitectura de gestión
 del estado se basa en la clase MyAppState, que extiende ChangeNotifier, lo que
 facilita la actualización y notificación de cambios en el estado de la aplicación a través
 de notifyListeners(). </p>
 <p>En términos de interfaz de usuario, la aplicación consta de dos páginas principales: la
 página generadora de palabras y la página de favoritos, ambas accesibles a través de
 un NavigationRail que facilita la navegación entre ellas. La página generadora
 muestra una palabra aleatoria junto con opciones para agregarla a favoritos o generar
 una nueva palabra. Mientras tanto, la página de favoritos permite buscar palabras en la
 lista de favoritos y ofrece acciones para eliminar palabras seleccionadas o agregar
 nuevas palabras aleatorias a la lista.</p>
 <p>Una característica destacada es la funcionalidad de búsqueda implementada en la
 página de favoritos, que filtra dinámicamente las palabras favoritas según el término
 de búsqueda ingresado por el usuario. Si bien esta función agrega valor a la
 aplicación, podría enfrentar desafíos de rendimiento con listas de favoritos muy largas
 si no se implementa de manera eficiente. En este sentido, sería prudente optimizar el
 algoritmo de búsqueda para garantizar un rendimiento óptimo, especialmente en
 dispositivos con recursos limitados.</p>
