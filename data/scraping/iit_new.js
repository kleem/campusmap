var webPage = require('webpage');
var utils = require('utils');
var x = require('casper').selectXPath;
var page = webPage.create();
var casper = require('casper').create({
    verbose: true,
    logLevel: 'debug',
    pageSettings: {
      loadImages:  true, // The WebPage instance used by Casper will
      loadPlugins: false, // use these settings
      userAgent: 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.2 Safari/537.36',
      XSSAuditingEnabled: false,
      localToRemoteUrlAccessEnabled: false
    }
});

var fs = require('fs');
//var csv = 'iit_new.csv';
var csv_groups = 'iit_gruppi_di_ricerca.csv';
var csv_people_iit = 'iit_persone.csv';
var csv_group_people = 'iit_persona_gruppo.csv';
var csv_referente_gruppo = 'iit_referente_gruppo.csv';
var csv_stanze = 'iit_stanze.csv';
var csv_persona_stanza = 'iit_persona_stanza.csv';

/* write CSV header
*/
fs.write(csv_groups, '"id","nome","descrizione","tipo","url"\n', 'w');
fs.write(csv_people_iit, '"id","nome","qualifica","descrizione","tags","email","tel","cel","fax","url_photo","url"\n', 'w');
fs.write(csv_group_people, '"id_gruppo","id_persona"\n', 'w');
fs.write(csv_referente_gruppo, '"id_referente","id_gruppo"\n', 'w');
fs.write(csv_stanze, '"id","nome","piano","ingresso","edificio"\n', 'w');
fs.write(csv_persona_stanza, '"id_persona","id_stanza"\n', 'w');

var research_group_links = [];
var people = [];

/*
research_group = [{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/389','name':'Algoritmi e matematica computazionale'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/26820','name':'Tassonomie, thesauri e sistemi di classificazione'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/388','name':'Sicurezza, Affidabilità e Privacy per l\'Internet del Futuro'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/386','name':'Ubiquitous Internet'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/2452','name':'Web Applications for the Future Internet'}]
techincal_service = [{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/395','name':'Registro .it'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/396','name':'Rete telematica CNR Pisa'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/397','name':'Servizi Internet e Sviluppo Tecnologico'}]
general_service = [{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/390','name':'Segreteria Amministrativa'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/391','name':'Segreteria del Personale'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/393','name':'Segreteria di Direzione'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/2124','name':'Segreteria Internet Governance'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/392','name':'Segreteria Scientifica'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/394','name':'Ufficio Tecnico e Servizi Ausiliari'}]
*/

starter_array = [{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/389','name':'Algoritmi e matematica computazionale'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/26820','name':'Tassonomie, thesauri e sistemi di classificazione'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/388','name':'Sicurezza, Affidabilità e Privacy per l\'Internet del Futuro'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/386','name':'Ubiquitous Internet'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/2452','name':'Web Applications for the Future Internet'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/395','name':'Registro .it'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/396','name':'Rete telematica CNR Pisa'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/397','name':'Servizi Internet e Sviluppo Tecnologico'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/390','name':'Segreteria Amministrativa'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/391','name':'Segreteria del Personale'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/393','name':'Segreteria di Direzione'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/2124','name':'Segreteria Internet Governance'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/392','name':'Segreteria Scientifica'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/394','name':'Ufficio Tecnico e Servizi Ausiliari'}]
//starter_array = [{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/392','name':'Segreteria Scientifica'},{'url':'http://www.iit.cnr.it/istituto/organizzazione?q=node/394','name':'Ufficio Tecnico e Servizi Ausiliari'}]

groups_id = 0;
people_id = 0;
referente_id = 0;
stanza_id = 0;
urls_people = [];
array_rooms = [];
casper.start('http://www.iit.cnr.it/', function() {
 
});

casper.then(function(){
    //anchors = casper.getElementsInfo('.article li a');
  starter_array.forEach(function(a) {
    casper.thenOpen(a.url, function(d,i){
      groups_id++
      if(casper.exists('#anteprima')){
        var descrizione = casper.getElementInfo('#anteprima').text.trim().replace(/     /g,' ')
      } else {
        var descriptions = casper.getElementsInfo('.article>*:not(table)')
        var descrizione = ""
        var tipo = ""
        descriptions.forEach(function(p,i){
          if(i<descriptions.length-1 && p.text.indexOf('Tipo') == -1){
            descrizione+=p.text.trim().replace(/     /g,' ').replace(/  /g,'')
          } else if (p.text.indexOf('Tipo') > -1) {
            tipo = p.text.replace("Tipo: ","")
          }
        })
        if(tipo == "" && casper.exists(x("//strong[text() = 'Servizio: ']/following::a"))){
          tipo = casper.getElementInfo(x("//strong[text() = 'Servizio: ']/following::a")).text
        }
      }
      /*
      
      */
      line_group = '"' + groups_id + '","' + a.name + '","' + descrizione + '","' + tipo + '","' + a.url + '"\n'
      fs.write(csv_groups, line_group, 'a');      

      casper.then(function(){
        casper.getElementsInfo('p.nome').forEach(function(d){
          referente_id++;
          if (d.html.indexOf('href') > -1){
            var href = d.html.split("<a href=\"")[1].split("\"")[0]  
          
          

            if(casper.exists(x('//div[@class="referente"]/p[@class="nome"]/a[text() = "'+d.text.replace("'","\'")+'"]'))){
              line_referente_group = '"' + referente_id + '","' + groups_id + '"\n'
              fs.write(csv_referente_gruppo, line_referente_group, 'a');   
            }
            var person_in_array = false;
            for(var i = 0; i<urls_people.length; i++) {
              if (urls_people[i]['url'] == href){
                person_in_array = true
                id_ok = urls_people[i]['id']
              }
            }
            
            if (!person_in_array) {
              
              casper.thenOpen('http://www.iit.cnr.it'+href, function(){
                people_id++;
                urls_people.push({"id":people_id,"url":href})
                nome = casper.getElementInfo('.PostHeader').text.trim();

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Email:']/following::td")))
                  if (casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Email:']/following::td")).text.replace(/\t/g, '').length>1)
                    email = "['"+casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Email:']/following::td")).text+"']";
                  else
                    email = '[]';
                else
                  email = '[]';

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Telefono:']/following::td")))
                  if (casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Telefono:']/following::td")).text.replace(/\t/g, '').length>1)
                    tel = "['"+casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Telefono:']/following::td")).text.replace(/\t/g, '').trim()+"']";
                  else
                    tel = '[]'

                else
                  tel = [];

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Cellulare:']/following::td")))
                  if (casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Cellulare:']/following::td")).text.replace(/\t/g, '').length>1) {
                    if (people_id == 86 ) {
                      console.log('length: '+casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Cellulare:']/following::td")).text.replace(/\t/g, '').length)
                    }  
                    if (casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Cellulare:']/following::td")).text.replace(/\t/g, '').length < 100) {
                      cel = "['"+casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Cellulare:']/following::td")).text.replace(/\t/g, '').trim()+"']";
                    }
                    else
                      cel = '[]';
                  }  else
                    cel = '[]';
                else
                  cel = '[]';

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Fax:']/following::td")))
                  if (casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Fax:']/following::td")).text.replace(/\t/g, '').length>1){
                    fax = "['"+casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Fax:']/following::td")).text.replace(/\t/g, '')+"']";  
                  } else {
                    fax = '[]'
                  }
                  
                else
                  fax = '[]';            

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Edificio:']/following::td")))
                  building = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Edificio:']/following::td")).text;
                else
                  building  = '';

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Piano:']/following::td")))
                  floor = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Piano:']/following::td")).text;
                else
                  floor  = '';
                
                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Stanza:']/following::td")))
                  room = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Stanza:']/following::td")).text;
                else
                  room  = '';

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Qualifica:']/following::td")))
                  qualifica = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Qualifica:']/following::td")).text.trim();
                else
                  qualifica  = '';

                if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Ingresso:']/following::td")))
                  gateway = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Ingresso:']/following::td")).text;
                else
                  gateway  = '';
                
                if (casper.exists('#descrizione-persona p')) {
                  descrizione = ''
                  description_p = casper.getElementsInfo('#descrizione-persona p').map(function(d){
                    descrizione += d.text
                  })
                } else
                  descrizione = '';
                
                
                var tags = '[';
                
                if (casper.exists('div#tags span.skill_field')){
                  tags_array_length = casper.getElementsInfo('div#tags span.skill_field');
                  tags_array = casper.getElementsInfo('div#tags span.skill_field').forEach(function(d,i){
                    if (i < tags_array_length.length-1) {
                      tags+= "'"+d.text+"',"  
                    } else {
                      tags+= "'"+d.text+"']"
                    }

                    
                  })
                } else {
                  tags = '[]';
                }

                if (casper.exists('#persona-left > img')) {
                  photo_url = 'http://www.iit.cnr.it/' + casper.getElementInfo("#persona-left > img").attributes.src;
                }
                else
                  photo_url = '';

                line_people = '"'+ people_id + '","' + nome + '","' + qualifica.trim() + '","' + descrizione.trim()+ '","' +tags+ '","'+email+ '","' +tel+ '","' +cel+ '","' +fax+ '","' +photo_url+'","[\'http://www.iit.cnr.it'+href+'\']"\n'
                fs.write(csv_people_iit, line_people, 'a');
                line_group_people = '"' + people_id + '","' + groups_id + '"\n'
                fs.write(csv_group_people, line_group_people, 'a');
                
                var room_in_array = false;
                for(var i = 0; i<array_rooms.length; i++) {
                  if (array_rooms[i]['name'] == room){
                    room_in_array = true
                  }
                }
                
                if (!room_in_array) {
                  stanza_id++;
                  array_rooms.push({"id":stanza_id,"name":room})
                  line_stanza = '"' + stanza_id + '","' + room + '","' + floor + '","' + gateway + '","' + building + '"\n'
                  fs.write(csv_stanze, line_stanza, 'a'); 
                }
                
                for(var i = 0; i<array_rooms.length; i++) {
                  if (array_rooms[i]['name'] == room){
                    id_stanza_ok = array_rooms[i]['id']
                    line_stanza_persona = '"' + people_id + '","' + id_stanza_ok + '"\n'
                    fs.write(csv_persona_stanza, line_stanza_persona, 'a');   
                  }
                }
              })      
            
            } else {
              line_group_people = '"' + id_ok + '","' + groups_id + '"\n'
              fs.write(csv_group_people, line_group_people, 'a');   
            }
          }          
        })
      })

    })
  });

})

casper.run();
