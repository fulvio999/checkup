import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import Ubuntu.Components.ListItems 1.3 as ListItem

/* to replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import "Storage.js" as Storage


/*
  Show a Dialog where the user can choose to delete ALL the saved data for a chosen entiy
 */
Dialog {
    id: dataBaseEraserDialog
    text: "<b>"+ i18n.tr("Select item type to remove")+"<br/>"+i18n.tr("(there is NO restore)")+ "</b>"

    Component {
        id: filterTypeSelectorDelegate
        OptionSelectorDelegate { text: name; }
    }

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

    Column{
          id: mainColumn
          spacing: units.gu(2)

          Row {
              anchors.horizontalCenter: parent.horizontalCenter
              Label {
                 text: i18n.tr("Removed ALL the saved data")
              }
          }

          Row{
               anchors.horizontalCenter: parent.horizontalCenter
               id:itemSelectorContainer
               width:  parent.width -units.gu(4)
               height: units.gu(12)

               ListItem.ItemSelector {
                        id: entityFilterTypeSelector
                        expanded:true
                        multiSelection:false
                        delegate: filterTypeSelectorDelegate
                        model: entityFilterModel
                        clip:false
                        containerHeight: itemHeight * 6
               }
            }

            /* transparent placeholder */
            Rectangle {
                  color: "transparent"
                  width: parent.width
                  height: units.gu(20)
            }

            Row{
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: units.gu(1)

                Button {
                      id: closeButton
                      width: units.gu(12)
                      text:  i18n.tr("Close")
                      onClicked: PopupUtils.close(dataBaseEraserDialog)
                }

                Button {
                        id: deleteButton
                        width: units.gu(12)
                        text:  i18n.tr("Delete")
                        color: UbuntuColors.orange
                        onClicked: {

                         var chosenValue = entityFilterModel.get(entityFilterTypeSelector.selectedIndex).value;
                         var deletedRecord = 0;

                         if(chosenValue === 1){
                            deletedRecord = Storage.deleteTable('blood_pressure');
                         }

                         else if(chosenValue === 2) {
                            deletedRecord = Storage.deleteTable('weight');
                         }

                         else if(chosenValue === 3) {
                            deletedRecord = Storage.deleteTable('hearth_pulse');
                         }

                         else if(chosenValue === 4) {
                            deletedRecord = Storage.deleteTable('glicemic');
                         }

                         deleteOperationResult.color = UbuntuColors.green
                         deleteOperationResult.text = i18n.tr("Done, removed successfully")+" "+deletedRecord+ " "+ i18n.tr("items")

                        }
                    }
                }

                Row{
                    anchors.horizontalCenter: parent.horizontalCenter
                    Label{
                        id: deleteOperationResult
                        text: " "
                    }
                }
      }

}
