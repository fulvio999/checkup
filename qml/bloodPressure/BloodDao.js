
/*
  DAO for blood_pressure entiy
*/


 function getDatabase() {
    return LocalStorage.openDatabaseSync("checkupApp_db", "1.0", "StorageDatabase", 1000000);
 }


 /* load stored data for blood Pressure taken in the given time interval */
 function loadBloodPressureData(dateFrom, dateTo){

         /* remove old values */
         bloodListModel.clear();

         //console.log("Loading blood pressure data from: "+dateFrom+" To: "+dateTo);

         var db = getDatabase();
         var rs = "";

         var to = new Date (dateTo);
         var from = new Date (dateFrom);

         /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
         var fullDateFrom = formatDateToString(from);
         var fullDateTo = formatDateToString(to);

         db.transaction(function(tx) {
             // min_value REAL, max_value REAL, date TEXT, notes TEXT
             rs = tx.executeSql("select * from blood_pressure b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"')");

            }
         );

         for(var i =0;i < rs.rows.length;i++) {
            bloodListModel.append({"id" : rs.rows.item(i).id, "minValue" : rs.rows.item(i).min_value, "maxValue" : rs.rows.item(i).max_value, "date": rs.rows.item(i).date, "notes": rs.rows.item(i).notes} );
           /* console.log("Found blood Pressure value: "+rs.rows.item(i).unit_name +" sourceUnitSymbol: "+rs.rows.item(i).source_unit_symbol); */
         }
  }


  /*
    Update an existing blood pressure measurement (date is not an editable, so that is not updated )
  */
  function updateBloodMeasure(minValue, maxValue, notes, id){

      var db = getDatabase();
      var res = "";

      db.transaction(function(tx) {
          var rs = tx.executeSql('UPDATE blood_pressure SET min_value=?, max_value=?, notes=? WHERE id=?;', [minValue, maxValue, notes, id]);
          if (rs.rowsAffected > 0) {
              res = "OK";
          } else {
              res = "Error";
          }
      }
      );
      return res;
  }


   /* insert a new blood pressure measure. Return true if insertion executed successfully */
  function insertMeasure(minValue, maxValue, date, notes){

        var db = getDatabase();
        var res = true;
        var fullDate = new Date (date);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var dateFormatted = formatDateToString(fullDate);

        db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT INTO blood_pressure (min_value, max_value, date, notes) VALUES (?,?,?,?);', [minValue, maxValue, dateFormatted, notes]);
            if (rs.rowsAffected > 0) {
                res = true;
            } else {
                res = false;
            }
        }
        );

        return res;
   }

   /* Check if a date a blood pressure value already exist at the given date.
      Return true if exist.
   */
   function bloodPressureExistForDate(targetDate){

        var db = getDatabase();
        var targetDate = new Date (targetDate);

        /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
        var fullTargetDate = formatDateToString(targetDate);
        var rs = "";

        /* get min_value o max_value is the same: is no possible insert only one value */
        db.transaction(function(tx) {
             rs = tx.executeSql("SELECT id FROM blood_pressure p where date(p.date) = date('"+fullTargetDate+"')");
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
      Delete the blood pressure entry with the given id
      Return true if item deleted successfully
    */
   function deleteBloodPressureEntry(id){

        var db = getDatabase();
        var res = true;
        var rs;

        db.transaction(function(tx) {
            rs = tx.executeSql('DELETE FROM blood_pressure WHERE id =?;',[id]);
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
      Y1:- pressure minimum value
      Y2:- pressure maximun value

      X: dates inside the interval
   */
   function getChartData(dateFrom, dateTo)
   {
        var ChartData = {
            labels: getXaxis(dateFrom, dateTo),
            datasets: [
                {
                    fillColor: "rgba(220,220,220,0.5)",  //Max values grey background
                    strokeColor: "rgba(220,220,220,1)",
                    data: getYaxisMaxValues(dateFrom, dateTo)
                },
                {
                    fillColor: "rgba(140,250,220,0.5)",   //Min values green background
                    strokeColor: "rgba(120,220,220,1)",
                    data: getYaxisMinValues(dateFrom, dateTo)
                }
            ]
        }
        return ChartData;
    }


    /*
      Y axis: blood pressure MAX values
    */
    function getYaxisMaxValues(dateFrom, dateTo){

         var to = new Date (dateTo);
         var from = new Date (dateFrom);

         /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
         var fullDateFrom = formatDateToString(from);
         var fullDateTo = formatDateToString(to);

         var db = getDatabase();
         var rs = "";
           db.transaction(function(tx) {
              rs = tx.executeSql("select max_value from blood_pressure b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"')");
            }
          );

         var measureValues = [];
         for(var i =0;i < rs.rows.length;i++) {
            measureValues.push(rs.rows.item(i).max_value);
         }

        return measureValues;
    }


    /*
      Y axis: blood pressure MIN values
    */
    function getYaxisMinValues(dateFrom, dateTo){

         var to = new Date (dateTo);
         var from = new Date (dateFrom);

         /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
         var fullDateFrom = formatDateToString(from);
         var fullDateTo = formatDateToString(to);

         var db = getDatabase();
         var rs = "";
           db.transaction(function(tx) {
              rs = tx.executeSql("select min_value from blood_pressure b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"')");
            }
          );

         var measureValues = [];
         for(var i =0;i < rs.rows.length;i++) {
            measureValues.push(rs.rows.item(i).min_value);
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
            rs = tx.executeSql("select date from blood_pressure b where date(b.date) <= date('"+fullDateTo+"') and date(b.date) >= date('"+fullDateFrom+"') order by b.date asc");
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
