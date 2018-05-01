import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Layouts 1.0



/*
  Application help page
*/
Page {
      id: manageAppPage
      visible: false

       header: PageHeader {
           title: i18n.tr("Help Page")
       }

      Column{
          id: manageSavedGigsUrl
          anchors.fill: parent
          spacing: units.gu(3.5)
          anchors.leftMargin: units.gu(2)

          Rectangle {
              color: "transparent"
              width: parent.width
              height: units.gu(3)
          }

          TextArea {
                width: parent.width
                height: parent.height
                readOnly: true
                autoSize: true
                placeholderText: i18n.tr("This App is a health monitor, diary created for a personal daily use.")+
                                 "<br/>"+i18n.tr("Allow to record some prameters of you health.")+
                                 "<br/>"+i18n.tr("Can create a graphical report to get an overview of your health")+
                                 "<br/><br/><b>"+i18n.tr("Each section is indipendent from the other ones. Use only of you interest")+"</b>"+
                                 "<br/><br/><b>"+i18n.tr("Blood Pressure:")+"</b>"+
                                 "<br/>"+i18n.tr("Record the pressure values of your blood")+
                                 "<br/><br/><b>"+i18n.tr("Weight:")+"</b>"+
                                 "<br/>"+i18n.tr("Record your weight and calculate you BMI (Body Mass Index)")+"<br/>"+
                                 "<br/>"+i18n.tr("BMI value lower 18.5 means Underweight")+"<br/>"+
                                 "<br/>"+i18n.tr("BMI value inside the interval [18.5 ; 25] means Normal")+"<br/>"+
                                 "<br/>"+i18n.tr("BMI value inside the interval [25 ; 30] means Obese")+"<br/>"+
                                 "<br/>"+i18n.tr("BMI value greater 30 means Overweight")+"<br/>"+
                                 "<br/><br/><b>"+i18n.tr("Hearth Pulse:")+"</b>"+
                                 "<br/>"+i18n.tr("Record your daily hearth pulse")+
                                 "<br/><br/><b>"+i18n.tr("Glycemic:")+"</b>"+
                                 "<br/>"+i18n.tr("Record your glycemic values")

           }

      }

}
