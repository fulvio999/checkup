import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

import QtQuick.LocalStorage 2.0

import "../ConfigurationDao.js" as ConfigurationDao
import "BloodDao.js" as BloodDao
import "../Utility.js" as Utility

/* import qml from a sub-folder */
import "../commons"

/*
  Blood Pressure MAIN PAGE for PHONE
*/
Page {
     id: bloodPressurePage
     visible: false

     header: PageHeader {
        title: i18n.tr("Blood Pressure")
     }

     /* set on page onCompleted event, used for chart legend */
     property string bloodUnitOfMeasure;

     Component.onCompleted:{
        var unit = ConfigurationDao.getConfigurationValue('blood_pressure', 'unit_of_measure');
        unitofMeasureLabel.text = unit;
        unitofMeasureLabelMax.text = unit;
        bloodUnitOfMeasure = unit;
     }

     Component {
        id: operationResultSuccessDialogue
        OperationResult{msg:i18n.tr("Success: value saved successfully")}
     }

     Component {
        id: operationResultFailureDialogue
        OperationResultFailure{msg:i18n.tr("Error performing the operation")}
     }

     Component {
        id: invalidInputDialogue
        OperationResultFailure{msg:i18n.tr("Error, Invalid input or missing value")}
     }

     Component {
        id: valueAlreadyPresentDialogue
        OperationResultFailure{msg:i18n.tr("Day value already inserted: edit from Diary")}
     }

     //------------Sub-Pages of Blood one --------------
     Component {
        id: bloodDiaryPagePhone
        BloodDiaryPagePhone{}
     }

     Component {
        id: bloodAnaliticPagePhone
        BloodAnaliticPagePhone{}
     }
     //---------------------------------------

      /*
        PopOver DatePicker for measure date
      */
      Component {
            id: popoverDatePickerComponent
            Popover {
                  id: popoverDatePicker

                  DatePicker {
                        id: timePicker
                        mode: "Days|Months|Years"
                        minimum: {
                            var time = new Date()
                            time.setFullYear('2000')
                            return time
                        }
                        /* when Datepicker is closed, is updated the date shown in the button */
                        Component.onDestruction: {
                            measureDateButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                        }
                }
          }
     }

     Flickable {
          id: bloodPressurePagePhoneFlickable
          clip: true
          contentHeight: Utility.getContentHeight()
          anchors {
                 top: parent.top
                 left: parent.left
                 right: parent.right
                 bottom: bloodPressurePage.bottom
                 bottomMargin: units.gu(2)
          }


          Column{
                id: bloodPressurePageColumn
                spacing: units.gu(2)
                anchors.fill: parent

                /* transparent placeholder: to place the content under the header */
                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: units.gu(6)
                }

                Row{
                    id: inserValueRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:units.gu(2)

                    Label{
                        id: minValueLabel
                        anchors.verticalCenter: minValueField.verticalCenter
                        text: "* "+i18n.tr("Min. Value")+":"
                    }

                    TextField{
                        id: minValueField
                        width: units.gu(20)
                        enabled:true
                    }

                    Label{
                        id: unitofMeasureLabel
                        anchors.verticalCenter: minValueField.verticalCenter
                        //text: set onCompleted page
                    }
               }

                Row{
                    id:maxValueRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:units.gu(2)

                    Label{
                        id: maxValueLabelMin
                        anchors.verticalCenter: maxValueField.verticalCenter
                        text: "* "+i18n.tr("Max. Value")+":"
                    }

                    TextField{
                        id: maxValueField
                        width: units.gu(20)
                        enabled:true
                    }

                    Label{
                        id: unitofMeasureLabelMax
                        anchors.verticalCenter: maxValueField.verticalCenter
                        //text: set onCompleted page
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:units.gu(2)

                    Label{
                        id: measureDateLabel
                        anchors.verticalCenter: measureDateButton.verticalCenter
                        text: i18n.tr("Date")+":"
                    }

                    /* open the popOver with DatePicker */
                    Button {
                       id: measureDateButton
                       width: units.gu(20)
                       text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                       onClicked: {
                          PopupUtils.open(popoverDatePickerComponent, measureDateButton)
                       }
                    }
                 }

                 //---------- (placeholder) --------
                 Row{
                    id: placeholderRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        id: placeholderLabel
                        text: " "
                    }
                 }

                 //------------ Notes -------------
                 Row{
                    id: notesRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: units.gu(1)

                    Label {
                        id: noteLabel
                        anchors.verticalCenter: notesTextArea.verticalCenter
                        text: i18n.tr("Notes")+":"
                    }

                    TextArea {
                        id: notesTextArea
                        textFormat:TextEdit.AutoText
                        height: units.gu(15)
                        width: bloodPressurePage.width - noteLabel.width - units.gu(2)
                        readOnly: false
                    }
                 }

                /* -------------- Info Row ------------- */
                Row{
                    id: infoRow
                    spacing: units.gu(3)
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id:infoLabel
                        text: i18n.tr("Note: the decimal separtor in use is '.'")
                    }
                    Label{
                        text: i18n.tr("* Field required")
                    }
                }

                /* -------------- Insert Row ------------- */
                Row{
                    id: insertRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    Button {
                       id: insertMeasureButton
                       width: units.gu(20)
                       text: i18n.tr("Insert")
                       onClicked: {
                          /* value must be present and numeric */
                          var isMinValueValid = Utility.checkinputText(minValueField.text);
                          var isMaxValueValid = Utility.checkinputText(maxValueField.text);

                          if(!isMinValueValid || !isMaxValueValid){
                              PopupUtils.open(invalidInputDialogue);

                          }else{
                              var valueExist = BloodDao.bloodPressureExistForDate(measureDateButton.text);
                              if(valueExist){
                                  PopupUtils.open(valueAlreadyPresentDialogue);
                              }else{

                              var result = BloodDao.insertMeasure(minValueField.text, maxValueField.text, measureDateButton.text, notesTextArea.text);
                              if(result){
                                  PopupUtils.open(operationResultSuccessDialogue);
                                  minValueField.text = "";
                                  maxValueField.text = "";
                                  notesTextArea.text = "";
                              }else{
                                  PopupUtils.open(operationResultFailureDialogue);
                              }
                            }
                          }
                       }
                    }
                }

                /* line separator */
                Rectangle {
                    color: "grey"
                    width: units.gu(100)
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: units.gu(0.1)
                }

                /* -------------- Command button Row ----------- */
                Row{
                    id: commandButtonRow
                    spacing: units.gu(2)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Button {
                       id: bloodDiaryButton
                       width: units.gu(20)
                       text: i18n.tr("Open Diary")
                       color: UbuntuColors.green
                       onClicked: {
                          /* diary page with search.edit measurement values */
                          pageStack.push(bloodDiaryPagePhone)
                       }
                    }

                    Button {
                        id: analiticsButton
                        width: units.gu(20)
                        text: i18n.tr("Analytics")
                        color: UbuntuColors.orange
                        onClicked: {
                           pageStack.push(bloodAnaliticPagePhone)
                        }
                    }
                }

             } //col

   }//flick

   /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: bloodPressurePagePhoneFlickable
        align: Qt.AlignTrailing
    }
}
