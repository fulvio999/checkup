import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.LocalStorage 2.0

import "Storage.js"  as Storage

/*
  Maintenance Page: the user can delete some old values about the save entity data inside a custom time orange.
  There is no restore
*/
Page {
     id: maintenancePage
     visible: false

     header: PageHeader {
        title: i18n.tr("Maintenance Page")
     }

     Component {
                id: entitySelectorDelegate
                OptionSelectorDelegate { text: name; }
            }

            /* The available Job filter criteria */
            ListModel {
                 id: entityFilterModel
            }


            /* fill listmodel using this method because allow you to use i18n */
            Component.onCompleted: {
                 entityFilterModel.append( { name: "<b>"+i18n.tr("Blood Pressure")+"</b>", value:1 } );
                 entityFilterModel.append( { name: "<b>"+i18n.tr("Weight")+"</b>", value:2 } );
                 entityFilterModel.append( { name: "<b>"+i18n.tr("Hearth Pulse")+"</b>", value:3 } );
                 entityFilterModel.append( { name: "<b>"+i18n.tr("Glicemic")+"</b>", value:4 } );
            }

     /* ----------- Ask confirmation before Delete items from Diary-------------- */
     Component {
             id: confirmDeleteItem

             Dialog {
                 id: confirmDeleteDialog
                 text: "<b>"+i18n.tr("Confirm deletion ?")+ "<br/>"+i18n.tr("(there is no restore)")+"</b>"

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

                                 var chosenValue = entityFilterModel.get(entityTypeSelector.selectedIndex).value;
                                 //console.log("Choosen item: "+chosenValue);

                                 var deletedRecord = 0;

                                 if(chosenValue === 1){
                                    deletedRecord = Storage.deleteEntityInTimeRange('blood_pressure', dateFromButton.text, dateToButton.text);
                                 }
                                 else if(chosenValue === 2) {
                                    deletedRecord = Storage.deleteEntityInTimeRange('weight', dateFromButton.text, dateToButton.text);
                                 }
                                 else if(chosenValue === 3) {
                                    deletedRecord = Storage.deleteEntityInTimeRange('hearth_pulse', dateFromButton.text, dateToButton.text);
                                 }
                                 else if(chosenValue === 4) {
                                    deletedRecord = Storage.deleteEntityInTimeRange('glicemic', dateFromButton.text, dateToButton.text);
                                 }

                                 resultLabel.text = i18n.tr("Deleted")+": "+deletedRecord+" "+i18n.tr("Items")
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
          id: mainColumn
          spacing: units.gu(4)
          anchors.fill: parent

          /* transparent placeholder: to place the content under the header */
          Rectangle {
             color: "transparent"
             width: parent.width
             height: units.gu(6)
          }

          Row{
              id:row1
              anchors.horizontalCenter: parent.horizontalCenter
              Label{
                 id: titleLabel
                 text: i18n.tr("Remove data from Diary indise a time range")
                 textSize: Label.Medium
               }
           }


           Row{
              id:row2
              anchors.horizontalCenter: parent.horizontalCenter
              spacing: units.gu(2)

              //------------ FROM ----------
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
          }

          Row{
              id:row3
              anchors.horizontalCenter: parent.horizontalCenter
              spacing: units.gu(4)

              //------------ TO --------
              Label{
                  id: toDateLabel
                  anchors.left : row3.rigth
                  anchors.verticalCenter: dateToButton.verticalCenter
                  text: i18n.tr("To")+":"
              }

              Button {
                 id: dateToButton
                 anchors.left : toDateLabel.rigth
                 width: units.gu(20)
                 text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                 onClicked: {
                     PopupUtils.open(dateToPickerComponent, dateToButton)
                 }
              }
           }

           Row{
               id: row4
               anchors.horizontalCenter: parent.horizontalCenter
               spacing: units.gu(2)

               Label{
                   id: entityTypeLabel
                   anchors.verticalCenter: itemSelectorContainer.verticalCenter
                   text: i18n.tr("Entity")+":"
                }

                Rectangle{
                      id:itemSelectorContainer
                      width:units.gu(20)
                      height:units.gu(7)

                      ListItem.ItemSelector {
                          id: entityTypeSelector
                          enabled:true
                          delegate: entitySelectorDelegate
                          model: entityFilterModel
                          clip:true
                          containerHeight: itemHeight * 4
                      }
                 }
            }

            /* transparent placeholder */
            Rectangle {
               color: "transparent"
               width: parent.width
               height: units.gu(6)
            }

            Row{
               id:row5
               anchors.horizontalCenter: parent.horizontalCenter
               spacing: units.gu(6)

               Label{
                   id: emptyLabel
                   anchors.verticalCenter: loadDataButton.verticalCenter
                   text: " "
               }

               Button {
                   id: loadDataButton
                   //anchors.left : emptyLabel.right
                   width: units.gu(20)
                   text: i18n.tr("Remove")
                   color: UbuntuColors.red

                   onClicked: {
                       PopupUtils.open(confirmDeleteItem,loadDataButton)
                   }
              }
          }
    }

}
