# 🍔 Sistema de Gestión Doña Sara (POS - Papas & Hamburguesas)
## 📝 1. Introducción

El **Sistema de Gestión Doña Sara** es una solución web de nivel empresarial para el Punto de Venta (POS) y administración de inventario/órdenes de un negocio gastronómico especializado en papas y hamburguesas. 

Construido bajo una arquitectura robusta, limpia y altamente escalable utilizando **Python** y el framework **Django**, este sistema ha sido concebido desde su origen para facilitar procesos de despliegue continuo (CI/CD) mediante contenedorización y orquestación con **Docker** y **Docker Compose**. La arquitectura backend interactúa de manera transparente tanto con bases de datos relacionales locales (SQLite para desarrollo ágil) como con motores de alto rendimiento en producción como **PostgreSQL**, garantizando persistencia de datos y consistencia transaccional óptima mediante volúmenes físicos dedicados.

---

## 🗂️ 2. Estructura del Proyecto

El proyecto está diseñado bajo una arquitectura modular de Django, dividiendo las responsabilidades lógicas en aplicaciones específicas dentro de la carpeta contenedora `app/`. A continuación, se presenta el árbol de directorios con sus componentes clave:

```text
S7-COMPONENTE-PR-CTICO_1_GESTION/
├── app/                       # Directorio contenedor de los módulos de negocio (Django Apps)
│   ├── orders/                # Módulo de gestión de pedidos, facturación y detalles de compra
│   │   ├── admin.py           # Registro en el panel de administración
│   │   ├── forms.py           # Formularios de validación de pedidos
│   │   ├── models.py          # Modelos de bases de datos para Order y OrderItem
│   │   ├── urls.py            # Enrutamiento de pedidos
│   │   └── views.py           # Controladores de la interfaz de pedidos y procesamiento de ventas
│   ├── products/              # Módulo de administración de productos y categorías del menú
│   │   ├── models.py          # Modelos de Categorías (Category) y Productos (Product)
│   │   └── ...
│   └── users/                 # Módulo de autenticación, control de perfiles y roles (admin, superowner, etc.)
│       ├── models.py          # Modelo de Perfil (Profile) extendido del usuario base
│       └── ...
├── doñaSara/                  # Módulo de configuración principal del proyecto Django
│   ├── settings.py            # Configuración general (Bases de datos, middleware, estáticos, apps)
│   ├── urls.py                # Enrutador de nivel superior (redirecciona a admin y a las apps)
│   ├── wsgi.py / asgi.py      # Interfaces de pasarela para servidores web de producción
│   └── __init__.py
├── static/                    # Archivos estáticos globales (CSS corporativo, JS, imágenes corporativas)
├── templates/                 # Plantillas HTML globales y base del sistema (`base.html`, etc.)
├── create_admin.py            # Script automatizado para creación inicial del superusuario administrador
├── datos_locales.json         # Fixture de datos iniciales en formato JSON (Usuarios locales, productos, órdenes v1)
├── nuevos_datos.json          # Fixture de datos actualizada (Usuarios actualizados, órdenes de prueba v2)
├── manage.py                  # Utilidad de línea de comandos para tareas administrativas de Django
├── requirements.txt           # Declaración de dependencias del proyecto (con sus versiones estrictas)
├── Dockerfile                 # Configuración de construcción de la imagen Docker (basada en python:3.11-slim)
└── docker-compose.yml         # Manifiesto de orquestación de servicios (Contenedores App Web + PostgreSQL)
```

---

## 🛠️ 3. Requisitos Previos

Antes de proceder con la instalación o el despliegue del sistema, asegúrese de contar con los siguientes elementos instalados en su entorno:

* **Para ejecución nativa local (Sin Docker):**
  * **Python 3.11.x** o superior.
  * **PostgreSQL** instalado localmente (en caso de querer conectarse directamente a una base de datos relacional externa) o soporte para SQLite por defecto.
  * Herramientas de desarrollo de Python y gestor de paquetes **pip**.

* **Para ejecución contenerizada (Con Docker - Recomendado):**
  * **Docker Engine** (v20.10+ recomendado).
  * **Docker Compose** (v2.0+ incluido en Docker Desktop).

---

## 🚀 4. Instalación y Configuración Local (Sin Docker)

Siga minuciosamente este flujo para preparar un entorno de desarrollo local aislado:

### Paso 1: Clonar e Ingresar al Directorio del Proyecto
Abra su terminal favorita en Windows (PowerShell o CMD) o Unix (Bash) y navegue hasta el directorio del espacio de trabajo

### Paso 2: Crear y Activar el Entorno Virtual (venv)
Es fundamental aislar las dependencias del sistema operativo local.
* **En Windows (PowerShell):**
  ```powershell
  python -m venv venv
  .\venv\Scripts\Activate.ps1
  ```
* **En Windows (CMD):**
  ```cmd
  python -m venv venv
  call venv\Scripts\activate.bat
  ```
* **En macOS/Linux (Bash):**
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  ```

### Paso 3: Instalar Dependencias
Una vez activado el entorno virtual, instale las librerías declaradas en `requirements.txt`:
```bash
pip install -r requirements.txt
```

### Paso 4: Configurar la Base de Datos y Ejecutar Migraciones
Inicialice la estructura de las tablas correspondientes a los modelos del sistema:
```bash
python manage.py migrate
```
*(Nota: Si no se configuran variables de entorno para PostgreSQL de forma local, el sistema utilizará de forma segura una base de datos SQLite por defecto).*

### Paso 5: Carga de Datos Iniciales (Fixtures JSON)
El proyecto cuenta con dos bases de datos preconfiguradas en formato JSON (`datos_locales.json` y `nuevos_datos.json`). Estas contienen información inicial valiosa como categorías del menú (Hamburguesas, Salchipapas, Bebidas), productos (Promo XXL Papi Pollo, Combo Mix, etc.), usuarios de prueba, y órdenes previas.

Ejecute los siguientes comandos para poblar la base de datos:
1. **Cargar datos iniciales del negocio:**
   ```bash
   python manage.py loaddata datos_locales.json
   ```
2. **Cargar la actualización de datos y nuevas órdenes:**
   ```bash
   python manage.py loaddata nuevos_datos.json
   ```

### Paso 6: Creación del Administrador del Sistema
Para acceder al sistema de administración de Django, puede automatizar la creación del superusuario por defecto usando el script incluido `create_admin.py`.

Inspeccionando el script, vemos que creará las siguientes credenciales por defecto:
* **Usuario:** `andres`
* **Correo:** `andres@donasara.com`
* **Contraseña:** `chelochelo2004@`

*Si desea personalizar estos valores antes de ejecutar, puede modificar las líneas 13 a 15 de [create_admin.py].*

Para ejecutar el script y crear el usuario, ejecute en su terminal:
```bash
python create_admin.py
```

### Paso 7: Ejecutar el Servidor de Desarrollo
Finalmente, inicie el servidor web de desarrollo incorporado de Django:
```bash
python manage.py runserver
```
La aplicación web estará disponible de inmediato en [http://localhost:8000/](http://localhost:8000/).

---

## 🐳 5. Despliegue Contenerizado (Con Docker)

El despliegue con Docker y Docker Compose encapsula toda la infraestructura, levantando una base de datos de producción **PostgreSQL 15-alpine** aislada y la aplicación web Django en contenedores interconectados mediante una red virtual interna.

### Paso 1: Levantar el Entorno Completo
Docker Compose se encargará de compilar la imagen de Django usando el `Dockerfile`, descargar la base de datos, configurar los volúmenes para persistencia y levantar el servidor web local con recarga en caliente mapeando el puerto `8000`:

```bash
docker-compose up --build -d
```
* **`--build`**: Fuerza la compilación de la imagen local si hay cambios en los requerimientos o el código.
* **`-d`**: Ejecuta los contenedores en segundo plano (detached mode).

### Paso 2: Automatización Interna de Tareas de Base de Datos
El contenedor de la aplicación web (`donasara_web_container`) automatiza los siguientes procesos clave al arrancar gracias a las directivas configuradas en el archivo `docker-compose.yml`:
1. Ejecución de migraciones automáticas (`python manage.py migrate`).
2. Recopilación de archivos estáticos globales para rendimiento de carga (`python manage.py collectstatic --noinput`).
3. Inicialización del servidor de Django escuchando en todas las interfaces del contenedor (`0.0.0.0:8000`).

### Paso 3: Carga de Datos y Fixtures dentro del Contenedor
Dado que la base de datos PostgreSQL de Docker arranca completamente vacía en el primer encendido, puede importar los datos de prueba (`datos_locales.json` y `nuevos_datos.json`) directamente dentro del contenedor web en ejecución:

```bash
# 1. Cargar datos base de locales e inventario
docker exec -it donasara_web_container python manage.py loaddata datos_locales.json

# 2. Cargar actualización de datos y órdenes
docker exec -it donasara_web_container python manage.py loaddata nuevos_datos.json
```

### Paso 4: Creación de Administrador en el Contenedor
De igual manera, puede crear de manera automatizada al superusuario `andres` dentro del contenedor web ejecutando el script especializado:

```bash
docker exec -it donasara_web_container python create_admin.py
```

En caso de requerir un usuario administrador alternativo o personalizado, puede utilizar el comando interactivo estándar de Django dentro del contenedor:
```bash
docker exec -it donasara_web_container python manage.py createsuperuser
```

---

## 🏛️ 6. Uso y Arquitectura del Sistema

### Acceso a las Interfaces del Sistema
Una vez levantado el servidor (local o en Docker), puede interactuar con el sistema a través de las siguientes URLs:

1. **Panel de Ventas (Punto de Venta / POS y Menu):**
   * **URL:** [http://localhost:8000/](http://localhost:8000/)
   * **Descripción:** Interfaz principal responsiva donde los cajeros y personal de ventas pueden registrar pedidos de combos, hamburguesas, bebidas, etc.

2. **Panel de Administración (Django Admin):**
   * **URL:** [http://localhost:8000/admin/](http://localhost:8000/admin/)
   * **Descripción:** Consola centralizada empresarial para la gestión de productos, inventario, categorías, perfiles de usuarios (roles de cajeros, administradores), y visualización de reportes analíticos de órdenes de venta.

### Credenciales por Defecto Disponibles en Datos Cargados:
* **Superusuario Principal (Generado por script o `nuevos_datos.json`):**
  * **Username:** `andres`
  * **Password:** `chelochelo2004@`
  * **Rol:** `superowner`

* **Superusuario Base Local (`datos_locales.json`):**
  * **Username:** `chelo`
  * **Email:** `josegomezxc18@gmail.com`
  * **Rol:** `admin`

### Persistencia y Resiliencia en Contenedores
El servicio de base de datos Postgres está configurado con un volumen físico persistente denominado `postgres_data`. Esto garantiza que, incluso si el contenedor se destruye con `docker-compose down`, toda la información correspondiente a nuevas órdenes, productos añadidos e histórico de ventas del POS **permanecerá segura** y se cargará automáticamente al volver a levantar el servicio.

---
*Desarrollado y mantenido con estándares de calidad Enterprise y DevOps.*
