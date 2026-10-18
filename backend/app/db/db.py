import os
from config import config
import psycopg
from psycopg.rows import dict_row


def get_db_connection():
    # Si Render proporciona una URL completa de conexión (DATABASE_URL), se usa directamente.
    database_url = os.getenv("DATABASE_URL")
    
    if database_url:
        conn = psycopg.connect(
            database_url,
            row_factory=dict_row
        )
    else:
        # Configuración tradicional mediante variables individuales (ideal para Docker Compose local)
        db_host = config.config.get("POSTGRES_HOST")
        db_port = config.config.get("POSTGRES_PORT")
        db_name = config.config.get("POSTGRES_DB")
        db_user = config.config.get("POSTGRES_USERNAME")
        db_password = config.config.get("POSTGRES_PASSWORD")

        conn = psycopg.connect(
            host=db_host,
            port=db_port,
            dbname=db_name,
            user=db_user,
            password=db_password,
            row_factory=dict_row
        )

    with conn.cursor() as cur:            
        cur.execute("""
            CREATE TABLE IF NOT EXISTS poem (
                id_poem SERIAL PRIMARY KEY,
                title VARCHAR(50) UNIQUE NOT NULL,
                text_poem TEXT NOT NULL,
                status VARCHAR(10) CHECK (status IN ('sent', 'draft')) DEFAULT 'draft',
                creation_day TIME DEFAULT NULL
            );
        """)
     
        cur.execute("ALTER TABLE poem ALTER COLUMN creation_day SET DEFAULT CURRENT_TIME;")
     
        conn.commit()
        
    return conn


def get_all_poems_db():
    """Consulta para obtener todos los poemas registrados."""
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT id_poem, title, text_poem, status, creation_day FROM poem;")
            return cur.fetchall()


def get_poem_by_title_db(title: str):
    """Busca un poema específico por su título único."""
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "SELECT id_poem, title, text_poem, status, creation_day FROM poem WHERE title = %s;",
                (title,)
            )
            return cur.fetchone()


def create_poem_db(title: str, text_poem: str, status: str = "draft"):
    """Inserta un nuevo poema en la base de datos y retorna el registro creado."""
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO poem (title, text_poem, status)
                VALUES (%s, %s, %s)
                RETURNING id_poem, title, text_poem, status, creation_day;
                """,
                (title, text_poem, status)
            )
            new_poem = cur.fetchone()
            conn.commit()
            return new_poem


def update_poem_db(id_poem: int, title: str, text_poem: str):
    """Actualiza el título y el texto completo de un poema existente."""
    with get_db_connection() as conn:
        with conn.cursor(row_factory=dict_row) as cur:
            cur.execute(
                """
                UPDATE poem 
                SET title = %s, text_poem = %s 
                WHERE id_poem = %s 
                RETURNING id_poem, title, text_poem, status, creation_day;
                """,
                (title, text_poem, id_poem)
            )
            updated_poem = cur.fetchone()
            conn.commit()
            return updated_poem


def delete_poem_db(id_poem: int):
    """Elimina un poema de la base de datos por su ID."""
    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                "DELETE FROM poem WHERE id_poem = %s RETURNING id_poem;",
                (id_poem,)
            )
            deleted_poem = cur.fetchone()
            conn.commit()
            return deleted_poem is not None