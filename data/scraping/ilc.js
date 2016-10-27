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
var csv = 'ilc.csv';
var links = [];
var last_link = 0;

/* write CSV header
*/
fs.write(csv, '"name","email","position","phone","building","floor","room","gateway","homepage","photo_url"\n', 'w');

casper.start('http://www.ilc.cnr.it/', function() {
  /*  get people links
  */
  for (var i = 0; i<8; i++) {
    casper.thenOpen('http://www.ilc.cnr.it/it/content/persone?page='+i, function(){
      anchors = casper.getElementsInfo('.views-field-title .field-content a');
      anchors.forEach(function(a) {
        links.push(a.attributes.href);
      });

    })
  }
});

function get_links(){
  
}

function open(link,i) {

  casper.thenOpen(link, function() {

    utils.dump("PAGE #"+i+" of "+links.length)
    //casper.capture('gg'+i+'.png')

    
    if (casper.exists('#content-wrap')) {
      
      name = casper.getElementInfo('.page-title').text;

      if (casper.exists('.field-name-field-email .field-items .field-item'))
        email = casper.getElementInfo('.field-name-field-email .field-items .field-item').text.replace(' (link sends e-mail)','');
      else
        email  = '';

       if (casper.exists('.field-name-field-telephone .field-items .field-item'))
        tel = casper.getElementInfo('.field-name-field-telephone .field-items .field-item').text.replace(/\t/g, '');
      else
        tel = '';

      if (casper.exists('.field-name-field-building .field-items .field-item'))
        building = casper.getElementInfo(('.field-name-field-building .field-items .field-item')).text;
      else
        building  = '';

      if (casper.exists('.field-name-field-floor .field-items .field-item'))
        floor = casper.getElementInfo('.field-name-field-floor .field-items .field-item').text;
      else
        floor  = '';

      if (casper.exists('.field-name-field-room .field-items .field-item'))
        room = casper.getElementInfo('.field-name-field-room .field-items .field-item').text;
      else
        room  = '';

      if (casper.exists('.field-name-field-qualification .field-items .field-item'))
        position = casper.getElementInfo('.field-name-field-qualification .field-items .field-item').text;
      else
        position  = '';

      if (casper.exists('.field-name-field-gateway .field-items .field-item'))
        gateway = casper.getElementInfo('.field-name-field-gateway .field-items .field-item').text;
      else
        gateway  = '';
    
      if (casper.exists('.field-name-field-image .field-items .field-item > img')) {
        photo_url = casper.getElementInfo('.field-name-field-image .field-items .field-item > img').attributes.src;
      }
      else
        photo_url = '';

      line = '"' + name + '","' + email + '","' + position + '","' + tel + '","' + building + '","' + floor + '","' + room + '","' + gateway + '","' + link + '","' + photo_url + '"\n'

      fs.write(csv, line, 'a');
    }
    
  });
}

casper.then(function() {
  links.forEach(function(l,i) {
    open('http://www.ilc.cnr.it'+l,i);

  });  
});

casper.run();
