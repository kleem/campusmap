import csv
import json

graph = {"nodes": [], "links": []}
last_id = 0
rooms = {}

# ROOMS and PEOPLE
# scraped from the institutes' web pages
def rooms_people(file_path, institute):
    global last_id

    with open(file_path) as csv_file:
        for d in csv.DictReader(csv_file, delimiter=',', quotechar='"'):
            d['id'] = last_id
            last_id += 1
            d['type'] = 'person'
            d['label'] = d['name']
            d['position'] = d['position']
            d['gateway'] = d['gateway']            
            d['icon'] = d['photo_url'] if d['photo_url'] != '' else 'http://www.iit.cnr.it/sites/default/files/images/people/default.male.jpg'
            d['institute'] = institute

            graph['nodes'].append(d)

            if d['label'] == '':
                del d['floor']
                d['fuori_sede'] = True
            elif d['floor'] == '':
                d['floor'] = 'T'

            # check if we also have to add the room
            if d['room'] not in rooms:
                rooms[d['room']] = {'id': last_id, 'label': d['room'], 'floor': d['floor'], 'gateway': d['gateway'], 'type': 'room', 'icon': 'img/door.png'}
                last_id += 1
                graph['nodes'].append(rooms[d['room']])

            room = rooms[d['room']]

            # link the person to the room (id-based link)
            graph['links'].append({'source': d['id'], 'target': room['id'], 'type': 'located_in'})

rooms_people('../scraping/iit.csv', 'IIT')
rooms_people('../scraping/isti.csv', 'ISTI')
rooms_people('../scraping/ilc.csv', 'ILC')

# CICLOPI
graph['nodes'].append({'id': last_id, 'label': 'cicloPI', 'img': 'img/ciclopi.jpg', 'phone': '800 005 640', 'homepage': 'http://www.ciclopi.eu/default.aspx', 'icon': '//lh3.ggpht.com/kg63cpruckhizjn_MxcxK0O7VSLrpbwk_VM9N1CgyKs4nHAziweQ72kejOAW7u1RC4oL=w300', 'type': 'bicycle', 'floor': 'T'})
last_id += 1

# Auditorium
graph['nodes'].append({'id': last_id, 'label': 'Auditorium', 'img': 'img/auditorium.jpg', 'type': 'room', 'floor': 'T'})
last_id += 1

# Canteen
graph['nodes'].append({'id': last_id, 'label': 'Canteen', 'img': 'img/canteen.jpg', 'email': 'comm-mensa@area.pi.cnr.it', 'phone': '+39 050 315 2048', 'icon': 'img/serenissima.png', 'homepage': 'http://www.area.pi.cnr.it/index.php/mensa', 'type': 'room', 'floor': 'T'})
last_id += 1

# Library
graph['nodes'].append({'id': last_id, 'label': 'Library', 'img': 'img/library.jpg', 'type': 'room', 'floor': 'T'})
last_id += 1

# Bus Stop 'Volpi CNR'
graph['nodes'].append({'id': last_id, 'label': 'Bus Stop San Cataldo', 'img': 'img/bus_stop_san_cataldo.jpg', 'phone': '+39 800 57 0530', 'icon': 'img/cpt.png', 'homepage': 'http://www.pisa.cttnord.it/', 'type': 'bus', 'floor': 'T'})
last_id += 1

print json.dumps(graph)
