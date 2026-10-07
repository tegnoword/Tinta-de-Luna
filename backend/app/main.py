import uvicorn
import strawberry

from fastapi import FastAPI
from strawberry.fastapi import GraphQLRouter
from model.shema import Query


schema = strawberry.Schema(query=Query)
graphql_app = GraphQLRouter(schema)

app = FastAPI()
app.include_router(graphql_app, prefix="/graphql")

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)