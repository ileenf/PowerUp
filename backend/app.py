from flask import Flask


def build_app():
    app = Flask(__name__)

    from routes import foods
    app.register_blueprint(foods)
    return app


if __name__ == '__main__':
    app = build_app()
    app.run(debug=True, host='0.0.0.0', port=8080)
