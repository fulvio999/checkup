
/*
  DAO for MyDoctor section (info about my doctor)
*/


 function getDatabase() {
    return LocalStorage.openDatabaseSync("checkupApp_db", "1.0", "StorageDatabase", 1000000);
 }


 /* load stored info about my doctor. Return "N/A" if no record found */
 function loadMyDoctorInfo(){

         var db = getDatabase();
         var rs;

         db.transaction(function(tx) {
              rs = tx.executeSql("SELECT * FROM my_doctor");
            }
         );

         /* check if value is missing or not */
         if (rs.rows.length > 0) {
           return rs.rows;
         } else {
             return "N/A"; /* not found */
         }
   }


  /*
    Update existing doctor info
  */
  function updateMyDoctorInfo(name, surname, phone, mobile, email, address, notes,id){

      var db = getDatabase();
      var res = "";

      db.transaction(function(tx) {
          var rs = tx.executeSql('UPDATE my_doctor SET name=?, surname=?, phone=?, mobile=?, email=?, address=?, notes=? WHERE id=?;', [name, surname, phone, mobile, email, address, notes, id]);
          if (rs.rowsAffected > 0) {
              res = "OK";
          } else {
              res = "Error";
          }
      }
      );
      return res;
  }


   /* Insert info about my doctor. Return true if insertion is executed successfully */
  function insertDoctorInfo(name, surname, phone, mobile, email, address, notes){

        //console.log("My Doctor, value to insert,name: "+name+", surname: "+surname+", phone: "+phone+", mobile: "+mobile+", email: "+email+", address: "+address+", notes: "+notes);

        var db = getDatabase();
        var res = true;

        var oldRecord = loadMyDoctorInfo();
        if(oldRecord !== "N/A")
        {
          //console.log("Found old record with id:"+oldRecord.item(0).id+", updating it...");
          return updateMyDoctorInfo(name, surname, phone, mobile, email, address, notes, oldRecord.item(0).id);
        }else {

            db.transaction(function(tx) {
                var rs = tx.executeSql('INSERT INTO my_doctor (name, surname, phone, mobile, email, address, notes) VALUES (?,?,?,?,?,?,?);', [name, surname, phone, mobile, email, address, notes]);
                if (rs.rowsAffected > 0) {
                    res = true;
                } else {
                    res = false;
                }
            }
            );

            return res;
        }
   }
