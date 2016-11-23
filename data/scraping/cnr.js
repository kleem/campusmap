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
var csv_cnr = 'cnr.csv';
var csv_departments = 'dipartimenti.csv';
var csv_institutes = 'istituti.csv';
var csv_department_institutes = 'dipartimenti_istituti.csv';

/* write CSV header
*/
fs.write(csv_cnr, '"nome","sigla","indirizzo","email","descrizione","url"\n', 'w');
fs.write(csv_departments, '"id","nome","abbreviazione","descrizione"\n', 'w');
fs.write(csv_institutes, '"id","nome","sigla","missione"\n', 'w');
fs.write(csv_department_institutes, '"id_dipartimento","id_istituto"\n', 'w');


casper.start('https://www.cnr.it/it/chi-siamo', function() {
  /*  get people links
  */
  homepage = 'https://www.cnr.it'
  title_cnr = 'Consiglio Nazionale delle Ricerce'
  sigla_cnr = 'CNR'
  description_cnr = "";
  description_cnr_all = casper.getElementsInfo('.field-items p')
  description_cnr_all.forEach(function(d,i){
    if (d.text.length > 1) {
      if(i != (description_cnr_all.length)-1) {
        description_cnr += d.text+"\n"

      } else {
        description_cnr += d.text
      }  
    } 
  })
  address_cnr = casper.getElementInfo('#footer-address p:first-child').text
  address_cnr = address_cnr.split(' - ')[1] + address_cnr.split(' - ')[2]
  email_cnr = casper.getElementInfo('#footer-address p:last-child a').text
  line = '"' + title_cnr + '","' + sigla_cnr + '","' + address_cnr + '","' + email_cnr + '","' + description_cnr + '","' + homepage + '"\n'
  fs.write(csv_cnr, line, 'a');

  casper.thenOpen('https://www.cnr.it/', function(){
    casper.then(function(){
      anchors = casper.getElementsInfo('#navigation-thematic-areas .nav.navbar-nav li a');
      anchors.forEach(function(a) {
        var url = a.attributes.href
        var nome_breve = a.text
        if(nome_breve[0] == " "){
          nome_breve = nome_breve.slice(1)
        }
        check_department(url,nome_breve)
      });
    
    })

  })
});
index_institute = 1;
index_department = 0;
function check_department(link,nome_breve) {
  console.log(link)
  
  casper.thenOpen('https://www.cnr.it'+link, function(d) {
    index_department++  
    console.log('---------------')
    console.log('# Aperta pagina dipartimento di '+nome_breve)
    console.log('---------------')
    var title = casper.getElementInfo('.page-header').text
    var description = casper.getElementInfo('.field-items').text
    line = '"' + index_department + '","' + title + '","' + nome_breve + '","' + description + '"\n'
    fs.write(csv_departments, line, 'a');
    casper.then(function(d){
      casper.click(x("//li[contains(@class, 'leaf')]/a[text() = 'Istituti']"))
      casper.then(function(){
        console.log('---------------')
        console.log('# Aperta pagina istituti di '+nome_breve)
        console.log('---------------')
        casper.getElementsInfo('.wrapper-istituto li a').forEach(function(d){
          casper.thenOpen('https://www.cnr.it'+d.attributes.href, function(){
            title_institute = casper.getElementInfo('.page-header').text.split(' (')[0]
            sigla_institute = casper.getElementInfo('.page-header').text.split('(')[1].split(')')[0]
            console.log('---------------')
            console.log('# Aperto istituto di '+title_institute)
            console.log('---------------')
            console.log(title_institute)
            //email_institute = casper.getElementInfo(x("//div[contains(@class, 'wrapper-istituto')]//p[text() = ' E-mail: ']/a")).text
            //console.log(email_institute)
            missione = casper.getElementInfo(x("//div[contains(@class, 'wrapper-istituto')]//h3[text() = 'Missione']/following::p")).text
            line = '"' + index_institute + '","' + title_institute + '","' + sigla_institute + '","' + missione.trim() + '"\n'
            fs.write(csv_institutes, line, 'a');
            line_institute_department = '"' + index_department + '","' + index_institute + '"\n'
            fs.write(csv_department_institutes, line_institute_department, 'a');
            index_institute++

          })
        })

      })
    })    
    
  })
  
}

casper.run();
