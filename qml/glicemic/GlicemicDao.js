
/*
  DAO for Glicemic
*/


 function getDatabase() {
    return LocalStorage.openDatabaseSync("checkupApp_db", "1.0", "StorageDatabase", 1000000);
 }


 /* load stored data for glicemic in the given time interval */
 function loadGlicemicData(dateFrom, dateTo){

         /* remove old values */
         glicemicListModel.clear();

         //console.log("Loading glicemic data from: "+dateFrom+" To: "+dateTo);

         var db = getDatabase();
         var rs = "";

         var to = new Date (dateTo);
         var from = new Date (dateFrom);

         /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
         var fullDateFrom = formatDateToString(from);
         var fullDateTo = formatDateToString(to);

         db.transaction(function(tx) {
              rs = tx.executeSql("select * from glicemic b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"')");
            }
         );

         //console.log("Found glicemic result: "+rs.rows.length)

         for(var i =0;i < rs.rows.length;i++) {
            glicemicListModel.append({"id" : rs.rows.item(i).id, "value" : rs.rows.item(i).value, "date" : rs.rows.item(i).date, "notes": rs.rows.item(i).notes} );
            /* console.log("Found glicemic value: "+rs.rows.item(i).value +" Date: "+rs.rows.item(i).date); */
         }
  }


  /*
    Update an existing glicemic measurement (date is not an editable, so that is not updated)
  */
  function updateGlicemicMeasure(value, notes, id){

      var db = getDatabase();
      var res = "";

      db.transaction(function(tx) {
          var rs = tx.executeSql('UPDATE glicemic SET value=?, notes=? WHERE id=?;', [value, notes, id]);
          if (rs.rowsAffected > 0) {
              res = "OK";
          } else {
              res = "Error";
          }
      }
      );
      return res;
  }


   /* insert a new glicemic measure. Return true if insertion is executed successfully */
  function insertGlicemicMeasure(value, date, notes){

        var db = getDatabase();
        var res = true;
        var fullDate = new Date (date);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var dateFormatted = formatDateToString(fullDate);

        db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT INTO glicemic (value, date, notes) VALUES (?,?,?);', [value, dateFormatted, notes]);
            if (rs.rowsAffected > 0) {
                res = true;
            } else {
                res = false;
            }
        }
        );

        return res;
   }

   /* Check if for the given date a glicemic measure value already exist.
      Return true if exist
   */
   function glicemicExistForDate(targetDate){

        var db = getDatabase();
        var targetDate = new Date (targetDate);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var fullTargetDate = formatDateToString(targetDate);
        var rs = "";

        /* get min_value o max_value is the same: is no possible insert only one value */
        db.transaction(function(tx) {
             rs = tx.executeSql("SELECT id FROM glicemic p where date(p.date) = date('"+fullTargetDate+"')");
           }
        );

        /* check if value is missing or not */
        if (rs.rows.length > 0) {
           return true;
        } else {
           return false; //not exist
        }
   }

   /*
      Delete the Glicemic measurement entry with the given id
      Return true if item deleted successfully
    */
   function deleteGlicemicEntry(id){

        var db = getDatabase();
        var res = true;
        var rs;

        db.transaction(function(tx) {
            rs = tx.executeSql('DELETE FROM glicemic WHERE id =?;',[id]);
          }
        );

        if (rs.rowsAffected > 0) {
           res = true;
        } else {
           res = false;
        }

        return res;
   }


   /*
      Extract the chart datasets:
      Y: value
      X: dates inside the interval
   */
   function getChartData(dateFrom, dateTo)
   {
        //console.log("Loading weigth data from: "+dateFrom+" To: "+dateTo);

        var ChartData = {
            labels: getXaxis(dateFrom, dateTo),
            datasets: [
                {
                    fillColor: "rgba(220,220,220,0.5)",  //weigth values grey background
                    strokeColor: "rgba(220,220,220,1)",
                    data: getYaxisWeigthValues(dateFrom, dateTo)
                }
            ]
        }
        return ChartData;
    }


    /*
      Y axis: hearth pulse measuremnt values
    */
    function getYaxisWeigthValues(dateFrom, dateTo){

         var to = new Date (dateTo);
         var from = new Date (dateFrom);

         /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
         var fullDateFrom = formatDateToString(from);
         var fullDateTo = formatDateToString(to);

         var db = getDatabase();
         var rs = "";
           db.transaction(function(tx) {
              rs = tx.executeSql("select value from glicemic b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"')");
            }
         );

         var measureValues = [];
         for(var i =0;i < rs.rows.length;i++) {
            measureValues.push(rs.rows.item(i).value);
         }

         return measureValues;
    }


    /*
      X axis: measurement dates
    */
    function getXaxis(dateFrom, dateTo){

        var to = new Date (dateTo);
        var from = new Date (dateFrom);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var fullDateFrom = formatDateToString(from);
        var fullDateTo = formatDateToString(to);

        var db = getDatabase();
        var rs = "";
        db.transaction(function(tx) {
            rs = tx.executeSql("select date from glicemic b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"')");
          }
        );

        /* build the array */
        var measureDates = [];
        for(var i =0;i < rs.rows.length;i++) {
           measureDates.push(rs.rows.item(i).date);
        }

        return measureDates;
    }


   /*
      Utility to format the javascript Date object to have double digit for day and month (default is one digit in js)
      return a string date like: YYYY-MM-DD
   */
   function formatDateToString(date)
   {
       var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
       var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
       var yyyy = date.getFullYear();

       return (yyyy + "-" + MM + "-" + dd);
   }
