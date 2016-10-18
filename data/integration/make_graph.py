import csv
import json

graph = {"nodes": [], "links": []}
last_id = 0
rooms = {}

with open('../scraping/iit.csv') as iit_csv:
    for d in csv.DictReader(iit_csv, delimiter=',', quotechar='"'):
        d['id'] = last_id
        last_id += 1
        d['type'] = 'person'
        d['label'] = d['name']
        d['institute'] = 'IIT'
        graph['nodes'].append(d)

        # check if we also have to add the room
        if d['room'] not in rooms:
            rooms[d['room']] = {'id': last_id, 'label': d['room'], 'floor': d['floor'], 'type': 'room'}
            last_id += 1
            graph['nodes'].append(rooms[d['room']])

        room = rooms[d['room']]

        # link the person to the room (id-based link)
        graph['links'].append({'source': d['id'], 'target': room['id'], 'type': 'located_in'})


print json.dumps(graph)
