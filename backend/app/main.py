import uvicorn
import strawberry
from fastapi import FastAPI
from strawberry.fastapi import GraphQLRouter
from model.shema import schema

from fastapi.middleware.cors import CORSMiddleware

graphql_app = GraphQLRouter(schema)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(graphql_app, prefix="/graphql")

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

