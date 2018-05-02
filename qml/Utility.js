
/* -------------------- Various utility functions -------------------- */

    /* utility functions to decide what value display in case of missing field value from DB */
    function getValueTodisplay(val) {

       if (val === undefined)
          return ""
       else
          return val;
    }

    /* return false if the input is not a number */
    function isNotNumeric(valueToCheck){
       return isNaN(valueToCheck);
     }

    /* used to check if a mandatory field is provided by the user */
    function isInputTextEmpty(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 )
           return true
        else
           return false;
    }

    /* check if mandatory field is numeric and present, return true if valid */
    function checkinputText(fieldTxtValue)
    {
        if (fieldTxtValue.length <= 0 || isNaN(fieldTxtValue))
           return false
        else
           return true;
    }

    /* return true if the input parameter contains comma sign */
    function containsComma(fieldTxtValue) {
        return /[,]|&#/.test(fieldTxtValue) ? true : false;
    }

    /* If regex matches, then string contains (at least) one special char. NOTE: '.' is allowed, is the decimal separators */
    function hasSpecialChar(fieldTxtValue) {
        /* dot sign is allowed because is the decimal separator */
        return /[<>?%#,;]|&#/.test(fieldTxtValue) ? true : false;
    }

    /* Show a information popup when the user open for the first time the application */
    function showOperationStatusDialog(){

         if(settings.isFirstUse){
            PopupUtils.open(operationStatusDialog)
         }
    }

    /* Depending on the Pagewidht of the Page (ie: the Device type) decide the Height of the scrollable */
    function getContentHeight(){
  console.log("-- landscapeWindow:----------- ");
        if(rootPage.width > units.gu(80))
            return configurationPage.height + configurationPage.height/2 + units.gu(20)
        else
            return configurationPage.height + configurationPage.height/2 + units.gu(10) //phone
    }

    /* depending on the page sixe return the width of the text field that show a saved jenkins url */
    function getTextFieldWidth(){

        if(rootPage.width > units.gu(110))
            return units.gu(60)
        else
            return units.gu(27) //phone
    }

    /* Return the todayDate with UTC values set to zero */
    function getTodayDate(){

        var today = new Date();
        today.setUTCHours(0);
        today.setUTCMinutes(0);
        today.setUTCSeconds(0);
        today.setUTCMilliseconds(0);

        return today;
    }


    /* Add the provided amount of days at the input date, if amount is negative, subtract them. The returned data has
       minutse,seconds,millisecond set to zero because are not important to track them
    */
    function addDaysToDate(date, days) {
        return new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate() + days,
            0,
            0,
            0,
            0
        );
    }


    /* Utility function to format the javascript date to have double digits for day and month (default is one digit in js)
       Example return date like: YYYY-MM-DD
       eg: 2017-04-28
    */
    function formatDateToString(date)
    {
       var dd = (date.getDate() < 10 ? '0' : '') + date.getDate();
       var MM = ((date.getMonth() + 1) < 10 ? '0' : '') + (date.getMonth() + 1);
       var yyyy = date.getFullYear();

       return (yyyy + "-" + MM + "-" + dd);
    }


    /* If input text is different from N/A return tha text as html hyper link */
    function getHyperLink(textToConvert){
        if(textToConvert === "N/A")
            return "N/A"
        else
          return colorLinks(i18n.tr("<a href=\"%1\">"+textToConvert+"</a>").arg(textToConvert))
    }


    /* to create a blue hyper link to show in a label */
    function colorLinks(text) {

        var linkColor = "blue";
        var t = "<a href=\"%1\">"+text+"</a>"

        return t.replace(/<a(.*?)>(.*?)</g, "<a $1><font color=\"" + linkColor + "\">$2</font><")
    }


    /* Depending on the Page widht of the Page (ie: the Device type) decide the offest heigth */
    function getOffsetAmount(){
        if(rootPage.width > units.gu(110))
            return units.gu(33) //tablet
        else
            return units.gu(41)
    }

    /* used to truncate jobs url too long in the phone job list page */
    function truncateUrlString(urlString){

        var length = 50;
        var newUrlString;

        if(rootPage.width > units.gu(110)){
            return urlString; //tablet: no truncate
        }else {

            if (urlString.length > length) {
                newUrlString = urlString.substring(0, length)+'...';
                //console.log("returning: "+newUrlString);
                return newUrlString;
            }else{
                return urlString
            }
        }
    }

    /* Depending on page size, return the width to use for a TextField */
    function getTextFieldReductionFactor(){
        if(root.width > units.gu(110))
            return units.gu(60) //tablet
        else
            return units.gu(18)
   }

   /* Depending on the Page width of the Page (ie: the Device type) decide the Height of the scrollable */
function getContentHeight(){
    if(root.width > units.gu(110))
        return root.height/2 + units.gu(20)
    else
        return root.height/2 + units.gu(40) //phone
}
