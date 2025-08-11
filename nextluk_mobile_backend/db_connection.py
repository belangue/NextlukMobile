import pymongo

url = 'mongodb://localhost:27017'
pymongo_client = pymongo.MongoClient(url)

db = pymongo_client['nextluk_db']
collection = db['nextluk_db']  # Replace with your collection name
