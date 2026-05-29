# 1. Imagen base oficial estable
FROM python:3.12-slim

# 2. Evitar que Python escriba archivos .pyc y forzar salida de logs directa
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# 3. Directorio de trabajo en el contenedor
WORKDIR /app

# 4. Instalar dependencias esenciales del sistema para compilar psycopg2 (PostgreSQL)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# 5. Instalar dependencias de Python
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# 6. Copiar el código del proyecto
COPY . /app/

# 7. Puerto expuesto para mapeo
EXPOSE 8000

# 8. Comando base alternativo si se corre de forma individual sin Compose
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]