from sqlalchemy import Column, Integer, String, ForeignKey
from .database import Base, db_session


class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(50), unique=True, nullable=False)
    email = Column(String(120), unique=True, nullable=False)

    def __init__(self, name, email):
        self.name = name
        self.email = email

    def __repr__(self):
        return '<User %r>' % self.name
