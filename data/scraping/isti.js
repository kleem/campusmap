var webPage = require('webpage');
var utils = require('utils');
var x = require('casper').selectXPath;
var page = webPage.create();
var casper = require('casper').create({   
    verbose: true, 
    logLevel: 'debug',
    pageSettings: {
      loadImages:  true, // The WebPage instance used by Casper will
      loadPlugins: true, // use these settings
      userAgent: 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.2 Safari/537.36',
      XSSAuditingEnabled: true,
      localToRemoteUrlAccessEnabled: true
    }
});

var fs = require('fs');
var csv = 'isti.csv';
var links = [];
var last_link = 0;

/* write CSV header
*/
fs.write(csv, '"name","email","phone","building","floor","room","homepage","photo_url"\n', 'w');

casper.start('http://www.isti.cnr.it/about/people.php', function() {

  /*  get people links
  */
  anchors = casper.getElementsInfo('.content p a');
  anchors.forEach(function(a) {
    links.push(a.attributes.href);
  });

});

function open(link,i) {
  
  casper.thenOpen(link, function() {

    utils.dump("PAGE #"+i+" of "+links.length)
    
    
    name = casper.getElementInfo('.shallow').text.slice(0,-1);

    if (casper.exists(x("//em[text() = 'email:']/following::td")))
      email = casper.getElementInfo(x("//em[text() = 'email:']/following::td")).text;
    else
      email  = '';

    if (casper.exists(x("//em[text() = 'office:']/following::td")))
      tel = casper.getElementInfo(x("//em[text() = 'office:']/following::td")).text.replace(/\t/g, '');
    else
      tel = '';

    if (casper.exists(x("//em[text() = 'building:']/following::td")))
      building = casper.getElementInfo(x("//em[text() = 'building:']/following::td")).text;
    else
      building  = '';

    if (casper.exists(x("//em[text() = 'floor:']/following::td")))
      floor = casper.getElementInfo(x("//em[text() = 'floor:']/following::td")).text;
    else
      floor  = '';

    if (casper.exists(x("//em[text() = 'room:']/following::td")))
      room = casper.getElementInfo(x("//em[text() = 'room:']/following::td")).text;
    else
      room  = '';
    
    /***
    if (casper.exists('#descrizione-persona p')) {
      description = ''
      description_p = casper.getElementsInfo('#descrizione-persona p').map(function(d){
        description += d.text 
      })
    } else
      description = '';

    description = '';
    line = '"' + name + '","' + email + '","' + tel + '","' + building + '","' + floor + '","' + room + '","' + description + '"\n'
    ***/

    if (casper.exists('#persona-left > img')) {
      photo_url = 'http://www.isti.cnr.it/' + casper.getElementInfo("#persona-left > img").attributes.src;
    }
    else
      photo_url = '';

    line = '"' + name + '","' + email + '","' + tel + '","' + building + '","' + floor + '","' + room + '","' + link + '","' + photo_url + '"\n'


    fs.write(csv, line, 'a');
  });
}

casper.then(function() {
  links.forEach(function(l,i) {
    open('http://www.isti.cnr.it'+l,i);
  });
});

casper.run();