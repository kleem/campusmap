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
var csv = 'iit.csv';
var links = [];
var last_link = 0;

/* write CSV header
*/
fs.write(csv, '"name","email","phone","building","floor","room","homepage","photo_url"\n', 'w');

casper.start('http://www.iit.cnr.it/en/institute/people', function() {
  /*  get people links
  */
  anchors = casper.getElementsInfo('.views-field-field-cognome-value a');
  anchors.forEach(function(a) {
    links.push(a.attributes.href);
  });

});

function open(link,i) {



  casper.thenOpen(link, function() {

    utils.dump("PAGE #"+i+" of "+links.length)

    name = casper.getElementInfo('.PostHeader').text;

    if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Email:']/following::td")))
      email = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Email:']/following::td")).text;
    else
      email  = '';

    if (casper.exists(x("//td[contains(@class, 'label') and text() = 'Telefono:']/following::td")))
      tel = casper.getElementInfo(x("//td[contains(@class, 'label') and text() = 'Telefono:']/following::td")).text.replace(/\t/g, '');
    else
      tel = '';

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

    // if (casper.exists('#descrizione-persona p')) {
    //   description = ''
    //   description_p = casper.getElementsInfo('#descrizione-persona p').map(function(d){
    //     description += d.text
    //   })
    // } else
    //   description = '';

    if (casper.exists('#persona-left > img')) {
      photo_url = 'http://www.iit.cnr.it/' + casper.getElementInfo("#persona-left > img").attributes.src;
    }
    else
      photo_url = '';

    line = '"' + name + '","' + email + '","' + tel + '","' + building + '","' + floor + '","' + room + '","' + link + '","' + photo_url + '"\n'

    fs.write(csv, line, 'a');
  });
}

casper.then(function() {
  links.forEach(function(l,i) {
    open('http://www.iit.cnr.it/'+l,i);

  });
});

casper.run();
