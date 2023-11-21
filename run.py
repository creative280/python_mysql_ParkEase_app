from flask import Flask
from flask_jsglue import JSGlue
from app import app, db

jsglue = JSGlue(app)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)
