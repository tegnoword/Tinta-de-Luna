import typing
import datetime
import strawberry
from db.db import get_db_connection, dict_row
from utils.whatsapp_links import generate_whatsapp_link

@strawberry.type
class PoemType:
    id_poem: int
    title: str
    text_poem: str
    status: str
    creation_day: typing.Optional[datetime.time] = None

    @strawberry.field
    def whatsapp_link(self, phone_number: typing.Optional[str] = None) -> str:
        """Genera el enlace de WhatsApp formateado para este poema específico"""
        return generate_whatsapp_link(self.title, self.text_poem, phone_number)


@strawberry.input
class PoemInput:
    title: str
    text_poem: str
    status: str = "draft"

@strawberry.input
class PoemUpdateInput:
    id_poem: int
    title: str
    text_poem: str    


@strawberry.type
class Query:
    @strawberry.field
    def get_poems(self) -> typing.List[PoemType]:
        """Obtiene todos los poemas de la base de datos"""
        with get_db_connection() as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                cur.execute("SELECT id_poem, title, text_poem, status, creation_day FROM poem;")
                rows = cur.fetchall()
        
        return [
            PoemType(
                id_poem=row["id_poem"],
                title=row["title"],
                text_poem=row["text_poem"],
                status=row["status"],
                creation_day=row["creation_day"]
            )
            for row in rows
        ]

    @strawberry.field
    def get_poem_by_title(self, title: str) -> typing.Optional[PoemType]:
        """Busca un poema por su título único en la base de datos"""
        with get_db_connection() as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                cur.execute(
                    "SELECT id_poem, title, text_poem, status, creation_day FROM poem WHERE title = %s;",
                    (title,)
                )
                row = cur.fetchone()
        
        if not row:
            return None
            
        return PoemType(
            id_poem=row["id_poem"],
            title=row["title"],
            text_poem=row["text_poem"],
            status=row["status"],
            creation_day=row["creation_day"]
        )


@strawberry.type
class Mutation:
    @strawberry.field
    def create_poem(self, input: PoemInput) -> PoemType:
        """Inserta un nuevo poema en la base de datos"""
        with get_db_connection() as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                cur.execute(
                    """
                    INSERT INTO poem (title, text_poem, status)
                    VALUES (%s, %s, %s)
                    RETURNING id_poem, title, text_poem, status, creation_day;
                    """,
                    (input.title, input.text_poem, input.status)
                )
                new_row = cur.fetchone()
                conn.commit()
        
        return PoemType(
            id_poem=new_row["id_poem"],
            title=new_row["title"],
            text_poem=new_row["text_poem"],
            status=new_row["status"],
            creation_day=new_row["creation_day"]
        )
    
    @strawberry.field
    def update_poem(self, input: PoemUpdateInput) -> typing.Optional[PoemType]:
        """Actualiza el título y texto completo de un poema"""
        with get_db_connection() as conn:
            with conn.cursor(row_factory=dict_row) as cur:
                cur.execute(
                    """
                    UPDATE poem 
                    SET title = %s, text_poem = %s 
                    WHERE id_poem = %s 
                    RETURNING id_poem, title, text_poem, status, creation_day;
                    """,
                    (input.title, input.text_poem, input.id_poem)
                )
                row = cur.fetchone()
                conn.commit()
        
        if not row:
            return None
            
        return PoemType(
            id_poem=row["id_poem"],
            title=row["title"],
            text_poem=row["text_poem"],
            status=row["status"],
            creation_day=row["creation_day"]
        )

    @strawberry.field
    def delete_poem(self, id_poem: int) -> bool:
        """Elimina un poema por su ID"""
        with get_db_connection() as conn:
            with conn.cursor() as cur:
                cur.execute(
                    "DELETE FROM poem WHERE id_poem = %s RETURNING id_poem;",
                    (id_poem,)
                )
                row = cur.fetchone()
                conn.commit()
        
        return row is not None


schema = strawberry.Schema(query=Query, mutation=Mutation)