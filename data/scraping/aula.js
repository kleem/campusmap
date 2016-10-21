var webPage = require('webpage');
var utils = require('utils');
var x = require('casper').selectXPath;
var page = webPage.create();
var casper = require('casper').create({
    verbose: false,
    //logLevel: 'debug',
    pageSettings: {
      loadImages:  true, // The WebPage instance used by Casper will
      loadPlugins: false, // use these settings
      userAgent: 'Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.2 Safari/537.36',
      XSSAuditingEnabled: false,
      localToRemoteUrlAccessEnabled: false
    }
});

var links = [];

var aula = casper.cli.get("aula");

var result = []
var new_array_links = []


var dateObj = new Date();
var month = dateObj.getUTCMonth() + 1; //months from 1-12
var day = dateObj.getUTCDate();
var year = dateObj.getUTCFullYear();

casper.start('http://prenota.isti.cnr.it/index.php?option=com_jevents&task=month.calendar&year='+year+'&month='+month+'&day='+day+'&Itemid=57', function() {
  /*  get all events links
  */
  anchors = casper.getElementsInfo('.cal_table tr td a.cal_titlelink');
  anchors.forEach(function(a) {
    
    /** Get just the events after TODAY
  
    if (parseInt(a.attributes.href.split('&day=')[1].split('&')[0])>=parseInt(day)){
      links.push({'link':a.attributes.href,'event_id':a.attributes.href.split('&uid=')[1]});
    }    

    **/

    links.push({'link':a.attributes.href,'event_id':a.attributes.href.split('&uid=')[1]});
    
  });
  

});

function open(link,i) {

  casper.thenOpen(link, function() {

    //utils.dump("PAGE #"+i+" of "+links.length)
    
    if (casper.exists(x("//td[@class='ev_detail' and contains(., '" + aula + "')]"))) {
      //utils.dump('Auditorium!!')

      if (casper.exists('.headingrow .contentheading'))
        event_name = casper.getElementInfo('.headingrow .contentheading').text
      else
        event_name = ''

      // usare questa stringa ' ' al posto dello spazio per prendere il &nbsp;
      if (casper.exists(x("//td[@class='ev_detail repeat' and contains(., 'From')]"))) {
        datetime = casper.getElementInfo(x("//td[@class='ev_detail repeat' and contains(., 'From')]")).text;
        from_date = datetime.split('From ')[1].split(' -  ')[0]
        from_time = datetime.split('From ')[1].split(' -  ')[1].split('To')[0]
        to_date = datetime.split('To ')[1].split(' - ')[0]
        to_time = datetime.split('To ')[1].split(' - ')[1]

        from_day = parseInt(from_date.split(' ')[1])
        from_month = parseInt(getMonthDays(from_date.split(' ')[2]))-1
        from_year = parseInt(from_date.split(' ')[3])

        to_day = parseInt(to_date.split(' ')[1])
        to_month = parseInt(getMonthDays(to_date.split(' ')[2]))-1
        to_year = parseInt(to_date.split(' ')[3])

        Date.prototype.days=function(to){
          return  Math.abs(Math.floor( to.getTime() / (3600*24*1000)) -  Math.floor( this.getTime() / (3600*24*1000)))
        }
        
        Date.prototype.addDays = function(days) {
          this.setDate(this.getDate() + parseInt(days));
          return this;
        };

      
        date_ok = new Date(from_year,from_month,from_day)
        next_first_day =new Date(date_ok.setDate(date_ok.getDate() + 3))
        
        var days = new Date(''+from_year+'/'+from_month+'/'+from_day+'').days(new Date(''+to_year+'/'+to_month+'/'+to_day+''))
        if (parseInt(to_month)-parseInt(from_month)!=0) {
          switch(parseInt(from_month)){
            case 1:
              days -=3
              break;
            case 3:
              days -=1
              break;
            case 5:
              days -=1
              break;
            case 8:
              days -=1
              break;
            case 10:
              days -=1
              break;

          }
        }
        for (var i = 0; i<days+1;i++){
          var newDate = new Date(from_year,from_month,from_day).addDays(i)
          result.push({'day':weekday[newDate.getDay()]+ ' ' + newDate.getDate() + ' '+months[newDate.getMonth()] + ' ' + newDate.getFullYear(), 'label':event_name,'from':from_time,'to':to_time})
        
        }
        return;
      } else if(casper.exists(x("//td[@class='ev_detail repeat']"))) {
        datetime = casper.getElementInfo(x("//td[@class='ev_detail repeat']")).text;
        from_date = datetime.split(', ')[0]
        from_time = datetime.split(', ')[1].split(' - ')[0]
        to_date = datetime.split(', ')[0]
        to_time = datetime.split(', ')[1].split(' - ')[1]
      } else {
        from_date  = '';
        from_time  = '';
        to_date  = '';
        to_time  = '';
      }

      result.push({'day':from_date, 'label':event_name,'from':from_time,'to':to_time})
      //line = '"' + event_name + '","' + from_date + '","' + from_time + '","' + to_date + '","' + to_time + '"\n'
      //fs.write(csv, line, 'a');

    }
      
  });
}

casper.then(function() {

  var uniqueNames = [];
  for(i = 0; i< links.length; i++){    
      if(uniqueNames.indexOf(links[i].event_id) === -1){
          uniqueNames.push(links[i].event_id);
          new_array_links.push(links[i].link)
      }        
  }

  casper.then(function(){
    new_array_links.forEach(function(l,i) {

      open('http://prenota.isti.cnr.it'+l,i);
    });  
  })
  
  casper.then(function(){
    utils.dump(result)
  })
});

casper.run();

function getMonthDays(MonthYear) {
  

  var Value=MonthYear      
  var month = (months.indexOf(Value) + 1);      
  return month;
}


var months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

var weekday = new Array(7);
weekday[0]=  "Sunday";
weekday[1] = "Monday";
weekday[2] = "Tuesday";
weekday[3] = "Wednesday";
weekday[4] = "Thursday";
weekday[5] = "Friday";
weekday[6] = "Saturday";

