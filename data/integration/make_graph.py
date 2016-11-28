import csv
import json

graph = {"nodes": [], "links": []}
last_id = 0
rooms = {}

wafi = {}

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
            d['icon'] = 'fa-user'
            if d['photo_url']:
                d['thumbnail'] = d['photo_url']
            d['institute'] = institute

            graph['nodes'].append(d)

            if d['name'] == 'Andrea Marchetti':
                wafi['am'] = d['id']
            elif d['name'] == 'Maria Claudia Buzzi':
                wafi['cb'] = d['id']
            elif d['name'] == 'Maurizio Tesconi':
                wafi['mt'] = d['id']
            elif d['name'] == 'Matteo Abrate':
                wafi['ma'] = d['id']

            if d['label'] == '':
                del d['floor']
                d['fuori_sede'] = True
            elif d['floor'] == '':
                d['floor'] = 'T'

            # check if we also have to add the room
            if d['room'] not in rooms:
                rooms[d['room']] = {'id': last_id, 'type': 'room', 'label': d['room'], 'floor': d['floor'], 'gateway': d['gateway'], 'icon': 'fa-square-o', 'thumbnail': 'img/door.png'}
                last_id += 1
                graph['nodes'].append(rooms[d['room']])

            room = rooms[d['room']]

            # link the person to the room (id-based link)
            graph['links'].append({'source': d['id'], 'target': room['id'], 'type': 'in'})

rooms_people('../scraping/iit.csv', 'IIT')
rooms_people('../scraping/isti.csv', 'ISTI')
rooms_people('../scraping/ilc.csv', 'ILC')

# Auditorium
graph['nodes'].append({'id': last_id, 'type': 'room', 'label': 'Auditorium', 'icon': 'fa-microphone', 'img': 'img/auditorium.jpg', 'floor': 'T'})
last_id += 1

# Canteen
graph['nodes'].append({'id': last_id, 'type': 'room', 'label': 'Mensa', 'icon': 'fa-cutlery', 'img': 'img/canteen.jpg', 'email': 'comm-mensa@area.pi.cnr.it', 'phone': '+39 050 315 2048', 'thumbnail': 'img/serenissima.png', 'homepage': 'http://www.area.pi.cnr.it/index.php/mensa', 'floor': 'T'})
last_id += 1

# Library
for n in graph['nodes']:
    if n['label'] == 'Library':
        n['icon'] = 'fa-book'
        n['img'] = 'img/library.jpg'

# Area della Ricerca
graph['nodes'].append({'id': last_id, 'type': 'building', 'icon': 'fa-building', 'label': 'Area della Ricerca di Pisa', 'img': 'img/cnr.jpg', 'phone': '+39 050 315 2111', 'thumbnail': 'img/cnr_icon.png', 'homepage': 'http://www.area.pi.cnr.it/', 'floor': '3', 'address': 'via G. Moruzzi, 156124 Pisa, Italy'})
area_id = last_id
last_id += 1

# IIT
iit = last_id
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': 'Istituto di Informatica e Telematica', 'img': 'img/cnr.jpg', 'phone': '+39 050 315 2112', 'thumbnail': 'img/iit.png', 'homepage': 'http://www.iit.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# ISTI
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Scienza e Tecnologie dell'Informazione", 'img': 'img/cnr.jpg', 'phone': '+39 050 315 2878', 'thumbnail': 'img/isti.jpg', 'homepage': 'http://www.isti.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# WAFI
graph['nodes'].append({'id': last_id, 'type': 'research_unit', 'icon': 'fa-sitemap', 'label': "Web Applications for the Future Internet", 'homepage': 'http://wafi.iit.cnr.it/'})
graph['links'].append({'source': last_id, 'target': iit, 'type': 'part_of'})
graph['links'].append({'source': wafi['cb'], 'target': last_id, 'type': 'part_of'})
graph['links'].append({'source': wafi['am'], 'target': last_id, 'type': 'part_of'})
graph['links'].append({'source': wafi['mt'], 'target': last_id, 'type': 'part_of'})
graph['links'].append({'source': wafi['ma'], 'target': last_id, 'type': 'part_of'})
last_id += 1

# Responsabile Area della Ricerca
graph['nodes'].append({'id': last_id, 'type': 'person', 'icon': 'fa-user', 'label': 'Ing. Ottavio Zirilli', 'thumbnail': 'img/zirilli.jpg', 'phone': '+39 050 315 2012', 'mobile': '+39 348 3907732', 'email':['zirilli@area.pi.cnr.it','ottavio.zirilli@cnr.it'], 'position': 'Responsabile Area', 'floor': '1'})

graph['links'].append({'source': last_id, 'target': area_id, 'type': 'manager_of'})
graph['links'].append({'source': 124, 'target': area_id, 'type': 'manager_of'})

last_id += 1

### External points
###

# Bus Stop 'Volpi CNR'
graph['nodes'].append({'id': last_id, 'type': 'bus', 'x': 50.34, 'y': 211.28, 'label': 'Fermata Bus San Cataldo', 'img': 'img/bus_stop_san_cataldo.jpg', 'phone': '+39 800 57 0530', 'icon': 'fa-bus', 'thumbnail': 'img/cpt.png', 'homepage': 'http://www.pisa.cttnord.it/', 'floor': 'T'})
last_id += 1

# CICLOPI
graph['nodes'].append({'id': last_id, 'type': 'bicycle', 'x': 233.81, 'y': 335.97, 'label': 'cicloPI', 'img': 'img/ciclopi.jpg', 'phone': '800 005 640', 'homepage': 'http://www.ciclopi.eu/default.aspx', 'icon': 'fa-bicycle', 'thumbnail': '//lh3.ggpht.com/kg63cpruckhizjn_MxcxK0O7VSLrpbwk_VM9N1CgyKs4nHAziweQ72kejOAW7u1RC4oL=w300', 'floor': 'T'})
last_id += 1

# Edicola
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-newspaper-o', 'x': 274.01, 'y': 235.52, 'label': 'Edicola', 'floor': 'T'})
last_id += 1

# ATM
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-credit-card', 'x': 203.76, 'y': 239.68, 'label': 'Bancomat', 'floor': 'T'})
last_id += 1

# Bank
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-euro', 'x': 260.11, 'y': 359.67, 'label': 'Banca Nazionale del Lavoro (BNL)', 'phone': '+39 050 571856', 'floor': 'T'})
last_id += 1

# TeCIP
graph['nodes'].append({'id': last_id, 'type': 'building', 'icon': 'fa-building', 'x': 364.85, 'y': 320.02, 'label': "Istituto di tecnologie della comunicazione, dell'informazione e della percezione (TeCIP)", 'phone': '+39 050 88 2099', 'thumbnail': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Uni_scuolasupsantanapisa_2.jpg/250px-Uni_scuolasupsantanapisa_2.jpg', 'homepage': 'http://www.sssup.it/tecip_en', 'floor': 'T'})
last_id += 1

# BAR IFC
graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 287.05, 'y': 240.73, 'label': 'Bar IFC', 'floor': 'T'})
last_id += 1

# BAR Mensa
graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 199.28, 'y': 264.22, 'label': 'Bar Mensa', 'floor': 'T'})
last_id += 1

# Guardiania
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-shield', 'x': 244.11, 'y': 356.72, 'label': 'Guardiania', 'floor': 'T'})
last_id += 1

# Fondazione Monasterio
graph['nodes'].append({'id': last_id, 'type': 'health', 'icon': 'fa-h-square', 'x': 278.39, 'y': 245.36, 'label': "Fondazione Toscana Gabriele Monasterio per la Ricerca Medica e di Sanita' Pubblica", 'homepage': 'https://www.ftgm.it/index.php/pisa-ospedale-di-ricerca-menu', 'floor': 'T'})
last_id += 1

# Totem
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-info', 'x': 231.3, 'y': 237, 'label': 'Totem', 'floor': 'T'})
last_id += 1

# Serra
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-leaf', 'x': 80, 'y': 158.4, 'label': 'Serra', 'floor': 'T'})
last_id += 1

print json.dumps(graph)
