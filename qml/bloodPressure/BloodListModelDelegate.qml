import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import QtQuick.LocalStorage 2.0

import "../Utility.js" as Utility
import "BloodDao.js" as BloodDao


   /*
     Delegate component used to display a saved Blood measure (minValue,maxValue date, notes...)
   */
   Item {
        id: bloodPressureItem
        width: bloodDiaryPage.width
        height: units.gu(20) /* heigth of the rectangle */

        /* create a container for each item */
        Rectangle {
            id: background
            x: 2; y: 2; width: parent.width - x*2; height: parent.height - y*1
            border.color: "black"
            radius: 5
        }

        /* This mouse region covers the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent

            onClicked: {
                /* move the highlight component to the currently selected item */
                listView.currentIndex = index
            }
        }

        /* create a row for each entry in the Model */
        Row {
            id: topLayout
            x: 10; y: 7; height: background.height; width: parent.width
            spacing: units.gu(4)

            Column {
                id: containerColumn
                width: topLayout.width - units.gu(10);
                height: bloodPressureItem.height
                anchors.verticalCenter: topLayout.Center
                spacing: units.gu(0.8)

                Row{
                    id:minValueRow
                    spacing:units.gu(1)
                    Label {
                         id: minValueLabel
                         anchors.verticalCenter: minValueTextField.verticalCenter
                         text: i18n.tr("Minimum Value")+":"
                         font.bold: true
                         fontSize: "medium"
                    }

                    TextField {
                          id: minValueTextField
                          hasClearButton: false
                          text: minValue
                          width: Utility.getTextFieldReductionFactor()
                          height:units.gu(4)
                          enabled: false
                    }

                    Label {
                          id: minPulseUniOfMeasureLabel
                          anchors.verticalCenter: minValueTextField.verticalCenter
                          text: bloodDiaryPage.bloodUnitOfMeasure
                          font.bold: true
                          fontSize: "medium"
                    }
                }

                Row{
                      id:maxValueRow
                      spacing:units.gu(1) // minValueLabel.text.length //+ 
                      Label {
                            id: maxValueLabel
                            anchors.verticalCenter: maxValueTextField.verticalCenter
                            text: i18n.tr("Maximum Value")+":"
                            font.bold: true
                            fontSize: "medium"
                      }

                      TextField {
                            id: maxValueTextField
                            x:minValueTextField.x
                            hasClearButton: false
                            text: maxValue
                            width: Utility.getTextFieldReductionFactor()
                            height:units.gu(4)
                            enabled: false
                      }

                      Label {
                            id: maxPulseUniOfMeasureLabel
                            anchors.verticalCenter: maxValueTextField.verticalCenter
                            text: bloodDiaryPage.bloodUnitOfMeasure
                            font.bold: true
                            fontSize: "medium"
                      }
                }

                Row{
                    id:dateRow
                    spacing: minValueLabel.text.length + units.gu(1)
                    Label {
                          id: dateLabel
                          anchors.verticalCenter: dateTextField.verticalCenter
                          text: i18n.tr("Date")+": "
                          font.bold: true
                          fontSize: "medium"
                    }
                    /* date is not editable. To update it, delete item and insert again */
                    Label {
                          id: dateTextField
                          x:minValueTextField.x
                          text: Qt.formatDateTime(date, "dd MMMM yyyy")
                    }
                }

                Row{
                    id:notesRow
                    spacing: minValueLabel.text.length + units.gu(2)
                    Label {
                          id: notesLabel
                          anchors.verticalCenter: notesButton.verticalCenter
                          text: i18n.tr("Notes")
                          font.bold: true
                          fontSize: "medium"
                    }

                    Button{
                      id:notesButton
                      x:minValueTextField.x
                      text: i18n.tr("Edit...")
                      enabled:false
                      onClicked: {
                          bloodDiaryPage.itemNotes = notes;
                          PopupUtils.open(updateNotesItem);
                      }
                    }
                }
            }

            Column{

              id: manageUrlColumn
              height: parent.height
              width: units.gu(7);
              spacing: units.gu(1)

              Rectangle {
                  id: placeholder2
                  color: "transparent"
                  width: parent.width
                  height: units.gu(0.1)
              }

              //---- Delete Item icon
              Row{
                  id:deleteUrlRow
                  Icon {
                      id: deleteUrlIcon
                      width: units.gu(3)
                      height: units.gu(3)
                      name: "delete"

                      MouseArea {
                          id: deleteUrlArea
                          width: deleteUrlIcon.width
                          height: deleteUrlIcon.height
                          onClicked: {
                              bloodDiaryPage.selectedItem = id;
                              PopupUtils.open(confirmDeleteItem);
                          }
                      }
                  }
              }

              //---- Edit Item icon
              Row{
                  id:editUrlRow
                  Icon {
                      id: editUrlIcon
                      width: units.gu(3)
                      height: units.gu(3)
                      name: "edit"

                      MouseArea {
                          width: editUrlIcon.width
                          height: editUrlIcon.height
                          onClicked: {
                              /* set the id and notes of the target item */
                              bloodDiaryPage.selectedItem = id;
                              bloodDiaryPage.itemNotes = notes;

                              minValueTextField.enabled = true;
                              maxValueTextField.enabled = true;
                              dateTextField.enabled = true;
                              notesButton.enabled = true;
                              saveRow.visible = true;
                          }
                      }
                  }
              }

              //------ Save/Update Item (shown when edit icon is selected) ----
              Row{
                  id:saveRow
                  visible: false

                  Icon {
                        id: editUrlIcon2
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "save"

                        MouseArea {
                            width: editUrlIcon.width
                            height: editUrlIcon.height
                            onClicked: {
                                //update
                                bloodDiaryPage.selectedItem = id;
                                BloodDao.updateBloodMeasure(minValueTextField.text, maxValueTextField.text,bloodDiaryPage.itemNotes, bloodDiaryPage.selectedItem );
                                BloodDao.loadBloodPressureData(dateFromButton.text, dateToButton.text); //refresh
                            }
                        }
                    }
                }

            }
        }
    }
