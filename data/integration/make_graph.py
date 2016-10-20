import csv
import json

graph = {"nodes": [], "links": []}
last_id = 0
rooms = {}

# ROOMS and PEOPLE
# scraped from the institutes' web pages
with open('../scraping/iit.csv') as iit_csv:
    for d in csv.DictReader(iit_csv, delimiter=',', quotechar='"'):
        d['id'] = last_id
        last_id += 1
        d['type'] = 'person'
        d['label'] = d['name']
        d['icon'] = d['photo_url']
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


# CICLOPI
graph['nodes'].append({'id': last_id, 'label': 'cicloPI', 'img': 'img/ciclopi.jpg', 'phone': '800 005 640', 'homepage': 'http://www.ciclopi.eu/default.aspx', 'icon': '//lh3.ggpht.com/kg63cpruckhizjn_MxcxK0O7VSLrpbwk_VM9N1CgyKs4nHAziweQ72kejOAW7u1RC4oL=w300', 'type': 'bicycle', 'floor': 'T'})
last_id += 1

# Auditorium
graph['nodes'].append({'id': last_id, 'label': 'Auditorium', 'img': 'img/auditorium.jpg', 'type': 'room', 'floor': 'T'})
last_id += 1

# Canteen
graph['nodes'].append({'id': last_id, 'label': 'Canteen', 'img': 'img/canteen.jpg', 'email': 'comm-mensa@area.pi.cnr.it', 'phone': '+39 050 315 2048', 'icon': 'http://www.rossicatering.it/userfiles/image/Serenissima%20logo.jpg', 'homepage': 'http://www.area.pi.cnr.it/index.php/mensa', 'type': 'room', 'floor': 'T'})
last_id += 1

# Library
graph['nodes'].append({'id': last_id, 'label': 'Library', 'img': 'img/library.jpg', 'type': 'room', 'floor': 'T'})
last_id += 1

print json.dumps(graph)
