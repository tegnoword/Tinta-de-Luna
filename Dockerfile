# Usamos una imagen ligera de Python 3.11 estable
FROM python:3.11-slim

# Instalamos curl, herramientas de compilación de C, libpq-dev y vim
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    libpq-dev \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Instalamos oficialmente 'uv' usando el script oficial
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Agregamos uv al PATH del sistema apuntando a la ruta donde se instala
ENV PATH="/root/.local/bin:$PATH"

# Establecemos el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiamos los archivos de configuración de dependencias desde la ruta correcta en el contexto
COPY backend/app/pyproject.toml backend/app/uv.lock* ./

# Instalamos las dependencias usando uv asegurando compatibilidad con python 3.11
RUN uv python pin 3.11 && (uv sync --frozen --no-dev || uv pip install --system -r pyproject.toml)

# Copiamos todo el contenido de la carpeta backend/app al directorio de trabajo del contenedor
COPY backend/app/ .

# Exponemos el puerto de FastAPI
EXPOSE 8000

# Comando para iniciar el servidor
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "${PORT:-8000}"]