import json

file = open("logs.json")
data = json.load(file)
print(data['logStreams'][1]['logStreamName'])

