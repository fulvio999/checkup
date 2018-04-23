import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.LocalStorage 2.0

import "../ConfigurationDao.js" as ConfigurationDao
import "BloodDao.js" as BloodDao
import "../Utility.js" as Utility

/*
  Page where the user can managed saved blood pressure data (ie the Diary):
  - search and Display
  - editable
*/
Page {
     id: bloodDiaryPage
     visible: false

     property int selectedItem;
     property string itemNotes;
     property string bloodUnitOfMeasure;

     Component.onCompleted:{
         bloodUnitOfMeasure = ConfigurationDao.getConfigurationValue('blood_pressure', 'unit_of_measure');
     }

     header: PageHeader {
        title: i18n.tr("Blood Pressure Diary")
     }

     /* a list of blood values saved */
     ListModel{
        id: bloodListModel
     }

     Component{
        id: bloodListModelDelegate
        BloodListModelDelegate{}
     }

     /* ----------- Ask confirmation for Deletion selected item -------------- */
     Component {
             id: confirmDeleteItem

             Dialog {
                 id: confirmDeleteDialog
                 text: "<b>"+i18n.tr("Remove selected Item ?")+ "<br/>"+i18n.tr("(there is no restore)")+"</b>"

                 Column{
                     spacing: units.gu(1)
                     Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: units.gu(4)
                        Button {
                             id: closeButton
                             text: i18n.tr("Close")
                             onClicked: PopupUtils.close(confirmDeleteDialog)
                         }

                         Button {
                             id: deleteButton
                             text: i18n.tr("Delete")
                             color: UbuntuColors.orange
                             onClicked: {
                                 var result = BloodDao.deleteBloodPressureEntry(bloodDiaryPage.selectedItem);
                                 if(result){
                                    resultLabel.color=  UbuntuColors.green
                                    resultLabel.text = i18n.tr("Item deleted successfully")
                                    BloodDao.loadBloodPressureData(dateFromButton.text, dateToButton.text); //refresh
                                 }else{
                                    resultLabel.color=  UbuntuColors.red
                                    resultLabel.text = i18n.tr("Error during deletion")
                                     BloodDao.loadBloodPressureData(dateFromButton.text, dateToButton.text);
                                 }
                             }
                         }
                     }

                     Row{
                       id:operationResultRow
                       anchors.horizontalCenter: parent.horizontalCenter
                       Label {
                         id:resultLabel
                         text: " "
                       }
                    }
              }
          }
     }
     /* ------------------------------------------------ */


     /* ---------------- Edit notes popUp ------------------- */
     Component {
             id: updateNotesItem

             Dialog {
               id: editNotesDialogue
               title: i18n.tr("Notes")

               Row {
                   anchors.horizontalCenter: parent.horizontalCenter
                   spacing: units.gu(1)
                   TextArea {
                       id:notesTextArea
                       width: parent.width
                       height: units.gu(20)
                       enabled: true
                       autoSize: false
                       horizontalAlignment: TextEdit.AlignHCenter
                       text: bloodDiaryPage.itemNotes
                   }
               }

               Row{
                   anchors.horizontalCenter: parent.horizontalCenter
                   spacing: units.gu(1)

                   Button {
                       id:confirmButton
                       text: i18n.tr("Confirm")
                       width: notesTextArea.width/2 - units.gu(1)
                       onClicked: {
                          bloodDiaryPage.itemNotes = notesTextArea.text
                          labelMsg.text = i18n.tr("Close and press save to confirm")
                          confirmButton.enabled = false
                      }
                   }

                   Button {
                       id:closeButton
                       text: i18n.tr("Close")
                       width: notesTextArea.width/2 - units.gu(1)
                       onClicked: PopupUtils.close(editNotesDialogue)
                   }
               }
               Row{
                  anchors.horizontalCenter: parent.horizontalCenter
                  Label{
                     id:labelMsg
                     text: " "
                     color: UbuntuColors.green
                  }
               }
          }
     }
     /* ------------------------------------------------------------------ */


     /*  DatePicker for FROM Date */
     Component {
                id: dateFromPickerComponent
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
                        Component.onDestruction: {
                             dateFromButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                        }
                  }
            }
       }

       /* DatePicker for TO Date  */
       Component {
                 id: dateToPickerComponent
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
                         Component.onDestruction: {
                             dateToButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                         }
                   }
             }
       }

       Column{
          id: bloodPressureDiaryColumn
          spacing: units.gu(4)
          anchors.fill: parent

          /* transparent placeholder: to place the content under the header */
          Rectangle {
             color: "transparent"
             width: parent.width
             height: units.gu(6)
          }

          Row{
            anchors.horizontalCenter: parent.horizontalCenter
            Label{
               id: titleLabel
               text: i18n.tr("Show saved blood pressure data")
               textSize: Label.Medium
           }
        }

        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(2)

            //------------ FROM --------
            Label{
                id: fromDateLabel
                anchors.verticalCenter: dateFromButton.verticalCenter
                text: i18n.tr("From")+":"
            }

            /* open the popOver component with DatePicker */
            Button {
               id: dateFromButton
               width: units.gu(20)
               text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
               onClicked: {
                   PopupUtils.open(dateFromPickerComponent, dateFromButton)
               }
            }

            //------------ TO --------
            Label{
                id: toDateLabel
                anchors.verticalCenter: dateToButton.verticalCenter
                text: i18n.tr("To")+":"
            }

            Button {
               id: dateToButton
               width: units.gu(20)
               text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
               onClicked: {
                   PopupUtils.open(dateToPickerComponent, dateToButton)
               }
            }

            Button {
               id: loadDataButton
               width: units.gu(20)
               text: i18n.tr("Load")
               color: UbuntuColors.green
               onClicked: {
                   BloodDao.loadBloodPressureData(dateFromButton.text, dateToButton.text);
                   resultSizeLabel.visible = true
               }
            }
        }

        /* Result row */
        Row{
          id: resultRow
          anchors.horizontalCenter: parent.horizontalCenter
          Label{
              id: resultSizeLabel
              visible:false
              text: i18n.tr("Total record found")+": "+bloodListModel.count
              textSize: Label.Medium
          }
        }
    }

    /* Display the loaded measurement values */
    UbuntuListView {
          id: listView
          anchors.fill: parent
          anchors.topMargin: units.gu(30) /* amount of space from the above component */
          model: bloodListModel
          delegate: bloodListModelDelegate

          /* disable the dragging of the model list elements */
          boundsBehavior: Flickable.StopAtBounds
          highlight: HighLigthComponent{}
          focus: true
          /* to prevent that UbuntuListView draw out of his assigned rectangle, default is false */
          clip: true
     }

     Scrollbar {
        flickableItem: listView
        align: Qt.AlignTrailing
     }
}
