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
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 168.1479, 'y': 245.0429, 'label': 'Auditorium', 'icon': 'fa-microphone', 'img': 'img/auditorium.jpg', 'floor': 'T'})
last_id += 1

# Mensa
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 189.3482, 'y': 273.6019, 'label': 'Mensa', 'icon': 'fa-cutlery', 'img': 'img/mensa.jpg', 'email': 'comm-mensa@area.pi.cnr.it', 'phone': '+39 050 315 2048', 'thumbnail': 'img/serenissima.png', 'homepage': 'http://www.area.pi.cnr.it/index.php/mensa', 'floor': 'T'})
last_id += 1

# Library
for n in graph['nodes']:
    if n['label'] == 'Library':
        n['icon'] = 'fa-book'
        n['img'] = 'img/library.jpg'
        n['homepage'] = 'http://library.isti.cnr.it/'
        n['x'] = 186.9286
        n['y'] = 216.4720

# Area della Ricerca
graph['nodes'].append({'id': last_id, 'type': 'building', 'icon': 'fa-building', 'label': 'Area della Ricerca di Pisa', 'img': 'img/cnr.jpg', 'address': 'via G. Moruzzi, 1 56124 Pisa, Italy', 'phone': '+39 050 315 2111', 'thumbnail': 'img/cnr_icon.png', 'homepage': 'http://www.area.pi.cnr.it/', 'floor': '3'})
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

# IFC
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Fisiologia Clinica", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ifc.png', 'homepage': 'http://www.ifc.cnr.it'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# IGG
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Geoscienze e Georisorse", 'img': 'img/cnr.jpg', 'thumbnail': 'img/igg.png', 'homepage': 'http://www.igg.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# ILC
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Linguistica Computazionale", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ilc.jpg', 'homepage': 'http://www.ilc.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# IN
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Neuroscienze", 'img': 'img/cnr.jpg', 'thumbnail': 'img/in.gif', 'homepage': 'http://www.in.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# IBF
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Biofisica", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ibf.png', 'homepage': 'http://www.ibf.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# IBBA
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Biologia e Biotecnologia Agraria", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ibba.png', 'homepage': 'http://www.ibba.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# ICCOM
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Chimica dei Composti Organo Metallici", 'img': 'img/cnr.jpg', 'thumbnail': 'img/iccom.png', 'homepage': 'http://www.iccom.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# ITB
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto di Tecnologie Biomediche", 'img': 'img/cnr.jpg', 'thumbnail': 'img/itb.png', 'homepage': 'http://www.itb.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# INO
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto Nazionale di Ottica", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ino.jpg', 'homepage': 'http://www.ino.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# IPCF
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto per i Processi Chimico-Fisici", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ipcf.jpg', 'homepage': 'http://www.ipcf.cnr.it/'})
graph['links'].append({'source': last_id, 'target': area_id, 'type': 'located_in'})
last_id += 1

# ISE
graph['nodes'].append({'id': last_id, 'type': 'institute', 'icon': 'fa-sitemap', 'label': "Istituto per lo Studio degli Ecosistemi", 'img': 'img/cnr.jpg', 'thumbnail': 'img/ise.png', 'homepage': 'http://www.ise.cnr.it/'})
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

# Fermata Bus San Cataldo
graph['nodes'].append({'id': last_id, 'type': 'bus', 'x': 50.34, 'y': 211.28, 'label': 'Fermata Bus San Cataldo', 'img': 'img/bus.jpg', 'phone': '+39 800 57 0530', 'icon': 'fa-bus', 'thumbnail': 'img/cpt.png', 'homepage': 'http://www.pisa.cttnord.it/', 'floor': 'T'})
last_id += 1

# Biblioteca ILC
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 186.78, 'y': 126.98, 'label': 'Biblioteca ILC', 'homepage': 'http://www.ilc.cnr.it/it/content/biblioteca', 'phone': '+39 050 315 2869', 'timetables': 'giorni feriali 9:30-16:00 (su appuntamento)', 'icon': 'fa-book', 'floor': '1', 'img': 'img/biblioteca_ILC.jpg'})
last_id += 1

# Aula Faedo
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 214.36, 'y': 191.09, 'label': 'Aula Faedo', 'icon': 'fa-microphone', 'floor': '1'})
last_id += 1

# C40
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 228.77, 'y': 183.13, 'label': 'C40', 'icon': 'fa-microphone', 'floor': '1', 'img': 'img/C40.jpg'})
last_id += 1

# A32
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 165.23, 'y': 220.33, 'label': 'A32', 'icon': 'fa-microphone', 'floor': '1'})
last_id += 1

# B76
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 147.79, 'y': 183.24, 'label': 'B76', 'icon': 'fa-microphone', 'floor': '1'})
last_id += 1

# Aula 27
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 167.73, 'y': 213.46, 'label': 'Aula 27', 'icon': 'fa-microphone', 'floor': 'T', 'capacity': 80})
last_id += 1

# Aula 28
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 182.27, 'y': 213.46, 'label': 'Aula 28', 'icon': 'fa-microphone', 'floor': 'T', 'capacity': 80})
last_id += 1

# Aula 29
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 196.43, 'y': 213.46, 'label': 'Aula 29', 'icon': 'fa-microphone', 'floor': 'T', 'capacity': 80})
last_id += 1

# Aula 30
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 199.94, 'y': 220.22, 'label': 'Aula 30', 'icon': 'fa-microphone', 'floor': 'T', 'capacity': 25})
last_id += 1

# Aula 40
graph['nodes'].append({'id': last_id, 'type': 'room', 'x': 196.52, 'y': 277.80, 'label': 'Aula 40 Franco Denoth', 'icon': 'fa-microphone', 'floor': '1', 'capacity': 40})
last_id += 1

# Asilo Eureka
graph['nodes'].append({'id': last_id, 'type': 'service', 'x': 101.05, 'y': 220.74, 'label': 'Asilo Eureka', 'icon': 'fa-smile-o', 'img': 'img/asilo_eureka.jpg', 'homepage': 'http://asilo.area.pi.cnr.it/', 'phone': '+39 050 315 3292', 'floor': 'T'})
last_id += 1

# DAE
graph['nodes'].append({'id': last_id, 'type': 'service', 'x': 199.40, 'y': 238.26, 'label': 'DAE', 'img': 'img/dae.jpg', 'icon': 'fa-heartbeat', 'floor': 'T'})
last_id += 1

# CICLOPI
graph['nodes'].append({'id': last_id, 'type': 'bicycle', 'x': 233.81, 'y': 335.97, 'label': 'cicloPI', 'img': 'img/ciclopi.jpg', 'phone': '800 005 640', 'homepage': 'http://www.ciclopi.eu/default.aspx', 'icon': 'fa-bicycle', 'thumbnail': '//lh3.ggpht.com/kg63cpruckhizjn_MxcxK0O7VSLrpbwk_VM9N1CgyKs4nHAziweQ72kejOAW7u1RC4oL=w300', 'floor': 'T'})
last_id += 1

# Edicola
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-newspaper-o', 'x': 274.01, 'y': 235.52, 'label': 'Edicola', 'floor': 'T', 'img': 'img/edicola.jpg'})
last_id += 1

# ATM Auditorium
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-credit-card', 'x': 203.76, 'y': 239.68, 'label': 'Bancomat Banco Popolare', 'floor': 'T', 'img': 'img/atm_auditorium.jpg'})
last_id += 1

# ATM IFC
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-credit-card', 'x': 275.38, 'y': 250.79, 'label': 'Bancomat BNL', 'floor': 'T', 'img': 'img/atm_IFC.jpg'})
last_id += 1

# Bank
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-euro', 'x': 260.11, 'y': 359.67, 'label': 'Banca Nazionale del Lavoro (BNL)', 'phone': '+39 050 571856', 'floor': 'T', 'img': 'img/bnl.jpg'})
last_id += 1

# Stampanti
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-print', 'x': 161.66, 'y': 190.31, 'label': 'HP Color Laserjet CP6015dn', 'img': 'img/HP_Color_Laserjet_CP6015dn.jpg', 'ip': '146.48.98.195', 'floor': '1'})
last_id += 1

graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-print', 'x': 162.74, 'y': 189.55, 'label': 'HP Laserjet 9040dn', 'img': 'img/HP_Laserjet_9040dn.jpg', 'ip': '146.48.96.71', 'floor': '1'})
last_id += 1

# TeCIP
graph['nodes'].append({'id': last_id, 'type': 'building', 'icon': 'fa-building', 'x': 364.85, 'y': 320.02, 'label': "Istituto di tecnologie della comunicazione, dell'informazione e della percezione (TeCIP)", 'phone': '+39 050 88 2099', 'thumbnail': 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1d/Uni_scuolasupsantanapisa_2.jpg/250px-Uni_scuolasupsantanapisa_2.jpg', 'homepage': 'http://www.sssup.it/tecip_en', 'floor': 'T', 'img': 'img/tecip.jpg'})
last_id += 1

# BAR IFC
graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 287.05, 'y': 240.73, 'label': 'Bar IFC','img': 'img/bar_ifc.jpg', 'floor': 'T'})
last_id += 1

# BAR Mensa
graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 199.28, 'y': 264.22, 'label': 'Bar Mensa', 'img': 'img/bar_mensa.jpg', 'floor': 'T'})
last_id += 1

# Distributori automatici
graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 327.72, 'y': 190.19, 'label': 'Distributori automatici', 'floor': '1', 'img': 'img/distributori_IFC.jpg'})
last_id += 1

graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 295.08, 'y': 128.04, 'label': 'Distributori automatici', 'floor': '1', 'img': 'img/distributori_IBF.jpg'})
last_id += 1

graph['nodes'].append({'id': last_id, 'type': 'food_drink', 'icon': 'fa-coffee', 'x': 151.32, 'y': 197.38, 'label': 'Distributori automatici', 'floor': 'T'})
last_id += 1

# Guardiania
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-shield', 'x': 244.11, 'y': 356.72, 'label': 'Guardiania', 'floor': 'T', 'img': 'img/guardiania.jpg'})
last_id += 1

# Fondazione Monasterio
graph['nodes'].append({'id': last_id, 'type': 'health', 'icon': 'fa-h-square', 'x': 278.39, 'y': 245.36, 'label': 'Reception Fondazione Toscana Gabriele Monasterio', 'img': 'img/monasterio.jpg', 'homepage': 'https://www.ftgm.it/index.php/pisa-ospedale-di-ricerca-menu', 'floor': 'T'})
last_id += 1

# Totem
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-info', 'x': 231.3, 'y': 237, 'label': 'Totem', 'floor': 'T', 'img': 'img/totem_esterno.jpg'})
last_id += 1

# Serra
graph['nodes'].append({'id': last_id, 'type': 'service', 'icon': 'fa-leaf', 'x': 80, 'y': 158.4, 'label': 'Serra', 'floor': 'T'})
last_id += 1

print json.dumps(graph)
