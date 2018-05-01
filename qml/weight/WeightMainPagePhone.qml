import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

import QtQuick.LocalStorage 2.0

import "WeightDao.js" as WeightDao
import "../ConfigurationDao.js" as ConfigurationDao
import "BmiCalculator.js" as BmiCalculator
import "../Utility.js" as Utility

/* import qml files from a sub-folder */
import "../commons"

/*
  weight MAIN PAGE for PHONE
*/
Page {
     id: weightPagePhone
     visible: false

     header: PageHeader {
        title: i18n.tr("Weight & BMI")
     }

     /* set on page onCompleted event */
     property string userHeigth; //user heigth value
     property string weightUnitOfMeasure; // weight unit of measure
     property string heigthUnitOfMeasure; //heigth unit of measure

     Component.onCompleted:{
        unitofMeasureLabel.text = ConfigurationDao.getConfigurationValue('weight', 'unit_of_measure');
        weightUnitOfMeasure = unitofMeasureLabel.text;

        var user_info_rs = ConfigurationDao.getUserInfo();
        var heigthValueAndUnitOfMeasure = user_info_rs.rows.item(0).heigth.split(' ');

        userHeigth = heigthValueAndUnitOfMeasure[0].trim();
        heigthUnitOfMeasure = heigthValueAndUnitOfMeasure[1].trim();
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
        id: weightDiaryPagePhone
        WeightDiaryPagePhone{}
     }

     Component {
        id: weightAnaliticPagePhone
        WeightAnaliticPagePhone{}
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
              id: weightPagePhoneFlickable
              clip: true
              contentHeight: Utility.getContentHeight()
              anchors {
                   top: parent.top
                   left: parent.left
                   right: parent.right
                   bottom: weightPagePhone.bottom
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
                          id: insertValueRow
                          x: bmiRow.x
                          spacing:units.gu(2)

                          Label{
                              id: blanceLabel
                              text: "  "
                          }

                          Label{
                              id: weightValueLabel
                              anchors.verticalCenter: weightValueField.verticalCenter
                              text: "* "+i18n.tr("weight")+":"
                          }

                          TextField{
                              id: weightValueField
                              width: units.gu(10)
                              enabled:true
                          }

                          Label{
                              id: unitofMeasureLabel
                              anchors.verticalCenter: weightValueField.verticalCenter
                              //text set on page completed
                          }
                        }

                        Row{
                          id:bmiRow
                          anchors.horizontalCenter: parent.horizontalCenter
                          spacing:units.gu(2)

                          Label{
                              id: bmiValueLabel
                              anchors.verticalCenter: bmiValueField.verticalCenter
                              text: "* "+i18n.tr("BMI Value")+":"
                          }

                          TextField{
                              id: bmiValueField
                              width: units.gu(16)
                              enabled:false
                          }

                          Button{
                              id: calculateBmiButton
                              anchors.verticalCenter: bmiValueField.verticalCenter
                              text: i18n.tr("Calculate")
                              onClicked: {
                                  if(! Utility.checkinputText(weightValueField.text)){
                                     PopupUtils.open(invalidInputDialogue);

                                  }else{
                                      var bmi = BmiCalculator.calculateBmi(weightValueField.text,userHeigth,weightUnitOfMeasure,heigthUnitOfMeasure);
                                      bmiValueField.text = bmi;
                                      bmiInfoLabel.text = i18n.tr("BMI description")+": "+BmiCalculator.getBmiDescription(bmi,i18n);

                                      bmiInfoLabel.font.bold = true
                                      bmiInfoLabel.fontSize = "medium"
                                  }
                              }
                           }
                       }

                       Row{
                            spacing:units.gu(2)
                            x: bmiRow.x + units.gu(5)

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

                       //---------- BMI value description --------
                       Row{
                          id: bmiDescriptionRow
                          anchors.horizontalCenter: parent.horizontalCenter
                          Label {
                              id: bmiInfoLabel
                              text: " " /* set after BMI calculation */
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
                              width: weightPagePhone.width - noteLabel.width - units.gu(2)
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
                              text: i18n.tr("Note: the decimal separator in use is '.'")
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
                                var isValueValid = Utility.checkinputText(weightValueField.text);
                                var isBmiValueValid = Utility.checkinputText(bmiValueField.text);

                                if(!isValueValid || !isBmiValueValid){
                                   PopupUtils.open(invalidInputDialogue);
                                }else{
                                    var valueExist = WeightDao.weightExistForDate(measureDateButton.text);

                                    if(valueExist){
                                       PopupUtils.open(valueAlreadyPresentDialogue);
                                    }else{

                                       var result = WeightDao.insertMeasure(weightValueField.text, bmiValueField.text, measureDateButton.text, notesTextArea.text);
                                       if(result){
                                           PopupUtils.open(operationResultSuccessDialogue);
                                           weightValueField.text = "";
                                           bmiValueField.text = "";
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
                                pageStack.push(weightDiaryPagePhone)
                             }
                          }

                          Button {
                              id: analiticsButton
                              width: units.gu(20)
                              text: i18n.tr("Analytics")
                              color: UbuntuColors.orange
                              onClicked: {
                                 pageStack.push(weightAnaliticPagePhone)
                              }
                          }
                      }
               } //col

    }//flick

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: weightPagePhoneFlickable
        align: Qt.AlignTrailing
    }
}
