from flask import Blueprint, jsonify, request
from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

client = MongoClient(os.getenv('DATABASE_URL'))
db = client['nutrition']

foods = Blueprint('api/foods', __name__, url_prefix='/api/foods')


@foods.route('/calories', methods=['GET'])
def calories():
    """
    Returns a list of foods with calories in a given range.
    """
    min = request.args.get('min', default=0, type=int)
    max = request.args.get('max', default=2000, type=int)
    limit = request.args.get('limit', default=5, type=int)
    range = {"$gte": min, "$lte": max} if max else {"$gte": min}
    cursor = db.foods.find(
        {"Data.Kilocalories": range},
        {"_id": 0}
    ).limit(limit)
    results = list(cursor)
    return jsonify(results)
