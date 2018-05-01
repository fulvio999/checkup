import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

import QtQuick.LocalStorage 2.0

import "HearthPulseDao.js" as HearthPulseDao
import "../ConfigurationDao.js" as ConfigurationDao

import "../Utility.js" as Utility

/* import qml files from a sub-folder */
import "../commons"

/*
  HEARTH PULSE PAGE for PHONE
*/
Page {
     id: hearthPulsePagePhone
     visible: false

     header: PageHeader {
        title: i18n.tr("Hearth Pulse")
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

     //------------Sub-Pages of Hearth Pulse one --------------
     Component {
        id: hearthPulseDiaryPagePhone
        HearthPulseDiaryPagePhone{}
     }

     Component {
        id: hearthPulseAnaliticPagePhone
        HearthPulseAnaliticPagePhone{}
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
           id: hearthPulsePagePhoneFlickable
           clip: true
           contentHeight: Utility.getContentHeight()
           anchors {
                 top: parent.top
                 left: parent.left
                 right: parent.right
                 bottom: hearthPulsePagePhone.bottom
                 bottomMargin: units.gu(2)
          }

          Column{
                id: hearthPulsePageColumn
                spacing: units.gu(2)
                anchors.fill: parent

                /* transparent placeholder: to place the content under the header */
                Rectangle {
                    color: "transparent"
                    width: parent.width
                    height: units.gu(6)
                }

                Row{
                    id: insertValueRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing:units.gu(1)

                    Label{
                        id: frequencyValueLabel
                        anchors.verticalCenter: frequencyValueField.verticalCenter
                        text: "* "+i18n.tr("Frequency")+":"
                    }

                    TextField{
                        id: frequencyValueField
                        width: units.gu(10)
                        enabled:true
                    }

                    Label{
                        id: unitofMeasureLabel
                        anchors.verticalCenter: frequencyValueField.verticalCenter
                        text: i18n.tr("bpm - beat per minute")
                    }
                 }

                 Row{
                    spacing:units.gu(1)
                    x: insertValueRow.x + units.gu(5)

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

                 //---------- placeholder Row --------
                 Row{
                    id: placeholderRow
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label {
                        id: placeHolderLabel
                        text: " "
                    }
                 }

                 //------------- Notes --------------
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
                        width: hearthPulsePagePhone.width - noteLabel.width - units.gu(2)
                        //  width: bloodPressurePage.width - noteLabel.width - units.gu(2)
                        readOnly: false
                    }
                 }

                /* -------------- Info Row ------------- */
                Row{
                    id: infoRow
                    spacing: units.gu(3)
                    anchors.horizontalCenter: parent.horizontalCenter

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
                          /* value must be not empty and numeric */
                          var isValueValid = Utility.checkinputText(frequencyValueField.text);

                          if(!isValueValid){
                            PopupUtils.open(invalidInputDialogue);

                          }else{
                              var valueExist = HearthPulseDao.hearthPulseExistForDate(measureDateButton.text);

                              if(valueExist){
                                  PopupUtils.open(valueAlreadyPresentDialogue);
                              }else{
                                  var insertResult = HearthPulseDao.insertHearthPulseMeasure(frequencyValueField.text, measureDateButton.text, notesTextArea.text);
                                  if(insertResult){
                                      PopupUtils.open(operationResultSuccessDialogue);
                                      frequencyValueField.text = "";
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
                       id: hearthPulseDiaryButton
                       width: units.gu(20)
                       text: i18n.tr("Open Diary")
                       color: UbuntuColors.green
                       onClicked: {
                          /* diary page with search,edit measurement values */
                          pageStack.push(hearthPulseDiaryPagePhone)
                       }
                    }

                    Button {
                        id: hearthPulseButton
                        width: units.gu(20)
                        text: i18n.tr("Analytics")
                        color: UbuntuColors.orange
                        onClicked: {
                           pageStack.push(hearthPulseAnaliticPagePhone)
                        }
                    }
                }
          } //col

   }//flick

   /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: hearthPulsePagePhoneFlickable
        align: Qt.AlignTrailing
    }
}
