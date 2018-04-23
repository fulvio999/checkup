
/*
   DAO used for configuration table:
   contains unit of measure for the various managed entity (eg: blood pressure...) and some user info
   (eg: heigth) fnecessary for some calculations like the BMI
*/

//------------------------------ UTILITY FUNCTIONS -----------------------------
    function getDatabase() {
        return LocalStorage.openDatabaseSync("checkupApp_db", "1.0", "StorageDatabase", 1000000);
    }
//------------------------------------------------------------------------------

  /* get ALL the configuration value fro the given entity (eg: blood_pressure, weight) */
  function getAllConfigurationValueByEntity(entityName) {

      var db = getDatabase();
      var rs;
      db.transaction(function(tx) {
          rs = tx.executeSql("SELECT * FROM configuration WHERE entity_name='"+entityName+"'");
      }
      );
  }

  /* get the saved user informations: name and height */
  function getUserInfo() {

      var db = getDatabase();
      var rs;

      db.transaction(function(tx) {
         rs = tx.executeSql("SELECT * FROM user_info");
      }
      );

      return rs; //the caller extract the values
  }

  /* Get a single configuration param_value for the given mamaged entity */
  function getConfigurationValue(entityName, paramName) {

      var db = getDatabase();
      var rs;

      db.transaction(function(tx) {
          rs = tx.executeSql("select param_value from configuration where entity_name='"+entityName+"' and param_name='"+paramName+"'");
      }
      );

      return rs.rows.item(0).param_value;
  }


 /* Insert configuration value for the provided managed entity */
 function insertConfigurationValue(entityName, paramName, paramValue) {

    if(settings.isFirstUse == true) //insert
    {
        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT INTO configuration (entity_name, param_name, param_value) VALUES (?,?,?);', [entityName, paramName, paramValue]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        }
        );
        return res;

      }else{
         return updateConfigurationValue(entityName, paramName, paramValue);
      }
  }


 /* Insert or update user informations, asked at first application startUp */
 function insertUserInfo(userId, userName, userHeigth, birthDay) {

   if(settings.isFirstUse == true) //insert
   {
      var db = getDatabase();
      var res = "";
      var fullDate = new Date (birthDay);

      /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
      var dateFormatted = formatDateToString(fullDate);

      db.transaction(function(tx) {
          var rs = tx.executeSql('INSERT INTO user_info (user_name, heigth, birthday) VALUES (?,?,?);', [userName, userHeigth, dateFormatted]);
          if (rs.rowsAffected > 0) {
              res = "OK";
          } else {
              res = "Error";
          }
      }
      );
      return res;

   }else{
      return updateUserInfo(userId, userName, userHeigth, birthDay);
   }
}


/* update user information data */
function updateUserInfo(userId,userName, userHeigth, birthDay){

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('UPDATE user_info SET user_name=?, heigth=?, birthday=? WHERE id=?;', [userName, userHeigth, birthDay, userId]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
    );
    return res;
}


/* update an existing configuration value for the given entity */
function updateConfigurationValue(entityName, paramName, paramValue){

    var db = getDatabase();
    var res = "";

    db.transaction(function(tx) {
        var rs = tx.executeSql('UPDATE configuration SET entity_name=?, param_name=?, param_value=? WHERE entity_name=? AND param_name=?;', [entityName,paramName,paramValue,entityName,paramName]);
        if (rs.rowsAffected > 0) {
            res = "OK";
        } else {
            res = "Error";
        }
    }
    );
    return res;
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
