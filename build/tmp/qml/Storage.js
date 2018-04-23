
/*
  DAO with the generic functions . For function related with a specific entity see js file inside entiy folder
*/

//----------------------------------- UTILITY FUNCTIONS --------------------------------

  function getDatabase() {
      return LocalStorage.openDatabaseSync("checkupApp_db", "1.0", "StorageDatabase", 1000000);
  }

//------------------------- Application INIT functions (invoked on firts use)------------------

 function initAppFirtsUse(){

   createBloodTable();
   createWeightTable();
   createHearthPulseTable();
   createGlicemicTable();
   createConfigurationTable();
   createUserInfoTable();
 }

//------------------------ CREATE TABLES: on for each entity managed by the App -----------------------

    /* BLOOD Pressure table */
    function createBloodTable() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS blood_pressure(id INTEGER PRIMARY KEY AUTOINCREMENT, min_value REAL, max_value REAL, date TEXT, notes TEXT)');
           });
    }

    /* WEIGHT table */
    function createWeightTable() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS weight(id INTEGER PRIMARY KEY AUTOINCREMENT, value REAL, date TEXT, bmi_value TEXT, notes TEXT)');
           });
    }

    /* HEARTH_PULSE table */
    function createHearthPulseTable() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS hearth_pulse(id INTEGER PRIMARY KEY AUTOINCREMENT, value REAL, date TEXT, notes TEXT)');
           });
    }

    /* GLICEMIC table */
    function createGlicemicTable() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS glicemic(id INTEGER PRIMARY KEY AUTOINCREMENT, value REAL, date TEXT, notes TEXT)');
           });
    }

    /* CONFIGURATION table: user of measurement */
    function createConfigurationTable() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS configuration(id INTEGER PRIMARY KEY AUTOINCREMENT, entity_name TEXT, param_name TEXT, param_value TEXT)');
           });
    }

    /* USER_INFO table: some user param: name and height (used to calculate BMI) */
    function createUserInfoTable() {
        var db = getDatabase();
        db.transaction(
           function(tx) {
               tx.executeSql('CREATE TABLE IF NOT EXISTS user_info(id INTEGER PRIMARY KEY AUTOINCREMENT, user_name TEXT, heigth TEXT, birthday TEXT)');
           });
    }

/* ------------------- Generic Utility functions ---------------------------- */
    function deleteTable(tableName){
        var db = getDatabase();
        var rs = "";
        db.transaction(
           function(tx) {
                rs = tx.executeSql('DELETE FROM '+tableName);
           });

        return rs.rowsAffected;
    }
/* -------------------------------------------------------------------------- */

/*
   Used in the maintenance page to remove entity data inside a provided time range.
   Retrun the number of record deletedRecord
*/
function deleteEntityInTimeRange(tableName, dateFrom, dateTo){

    console.log("Deleting data from table: "+tableName+" from date: "+dateFrom+" To data: "+dateTo)

    var db = getDatabase();
    var rs = "";

    var to = new Date (dateTo);
    var from = new Date (dateFrom);

    /* return a formatted date like: 2017-04-30 (yyyy-mm-dd) */
    var fullDateFrom = formatDateToString(from);
    var fullDateTo = formatDateToString(to);

    db.transaction(
       function(tx) {
            rs = tx.executeSql("DELETE FROM "+tableName+" where date(date) <= date('"+fullDateTo+"') and date(date) >= date('"+fullDateFrom+"')");
       });

    return rs.rowsAffected;
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
