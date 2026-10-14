from config import config
import psycopg
from psycopg.rows import dict_row


def get_db_connection():
    """Establece la conexión a PostgreSQL, asegura que la tabla exista y retorna la conexión."""
    conn = psycopg.connect(
        host=config.config.get("POSTGRES_HOST", "postgres"),  # Valor por defecto si no se encuentra la variable de entorno
        port=config.config.get("PORT"),
        dbname=config.config.get("POSTGRES_DB"),
        user=config.config.get("POSTGRES_USERNAME"),
        password=config.config.get("POSTGRES_PASSWORD"),
        row_factory=dict_row  # Permite recibir los resultados como diccionarios
    )

    with conn.cursor() as cur:            
        cur.execute("ALTER TABLE poem ALTER COLUMN creation_day SET DEFAULT CURRENT_TIME;")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS poem (
                id_poem SERIAL PRIMARY KEY,
                title VARCHAR(50) UNIQUE NOT NULL,
                text_poem TEXT NOT NULL,
                status VARCHAR(10) CHECK (status IN ('sent', 'draft')) DEFAULT 'draft',
                creation_day TIME DEFAULT NULL
            );
        """)
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