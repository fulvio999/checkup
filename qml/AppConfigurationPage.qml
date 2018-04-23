import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Qt.labs.settings 1.0
import QtQuick.LocalStorage 2.0

import "ConfigurationDao.js" as ConfigurationDao
import "Utility.js" as Utility

/* import qml files from a sub-folder */
import "./commons"

import Ubuntu.Components.ListItems 1.3 as ListItem

//----------------- App Configuration page -----------------
     Page {
             id: manageAppPage
             visible: false

             /* the id of the loaded user */
             property string userId;

             header: PageHeader {
                 title: i18n.tr("Application Configuration")
             }

             Component.onCompleted: {

                 /* if NOT the first use, load currently saved config from: 'user info' and 'configuration' tables */
                 if(settings.isFirstUse == false)
                 {
                     //------------- user_info -------------
                     var user_info_rs = ConfigurationDao.getUserInfo();
                     userId = user_info_rs.rows.item(0).id;
                     userNameField.text = user_info_rs.rows.item(0).user_name
                     var heigthValueAndUnitOfMeasure = user_info_rs.rows.item(0).heigth.split(' ');

                     userHeigthField.text = heigthValueAndUnitOfMeasure[0].trim();  //value
                     var heigthUnitOfMeasure = heigthValueAndUnitOfMeasure[1].trim(); //unit of measure

                     if(heigthUnitOfMeasure === 'cm'){
                        centimeterCheckBox.checked = true;
                     }else if (heigthUnitOfMeasure === 'in'){
                        inchesCheckBox.checked = true;
                     }else{
                        centimeterCheckBox.checked = true; //default
                     }

                     birthdayField.text = Qt.formatDateTime(new Date(user_info_rs.rows.item(0).birthday), "dd MMMM yyyy")
                     //------------------------------------

                     //---------- Blood Pressure ----------
                     bloodPressureField.text = ConfigurationDao.getConfigurationValue('blood_pressure', 'unit_of_measure');

                     //--------------- weight -------------
                     var weightUnitOfMeasure = ConfigurationDao.getConfigurationValue('weight', 'unit_of_measure');

                     if(weightUnitOfMeasure === 'kg'){
                         kilogramCheckBox.checked = true;

                     }else if (weightUnitOfMeasure === 'lb'){
                         libresCheckBox.checked = true;

                     }else{
                         kilogramCheckBox.checked = true; //default
                     }
                     //---------------------------------------

                     //---------------- Glicemic -------------
                     glicemicField.text = ConfigurationDao.getConfigurationValue('glicemic', 'unit_of_measure');
                 }
                 //else: show empy form with defaults
             }

             Component {
                id: operationResultSuccessDialogue
                OperationResult{msg:i18n.tr("Value saved, **RESTART** the application")}
             }

             Component {
                id: missingRequiredFieldDialogue
                OperationResult{msg:i18n.tr("ATTENTION: fill required fields")}
             }

             Component {
                id: missingUnitOfMeasureDialogue
                OperationResult{msg:i18n.tr("ATTENTION: check unit of measure")}
             }

             /*
               PopOver DatePicker for birtday
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
                                   birthdayField.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                               }
                     }
               }
          }


          Flickable {
                   id: manageAppPageFlickable
                   clip: true
                   contentHeight: Utility.getContentHeight()
                   anchors {
                          top: parent.top
                          left: parent.left
                          right: parent.right
                          bottom: manageAppPage.bottom
                          bottomMargin: units.gu(2)
                    }

               Column{
                      id: bloodPressureDiaryColumn
                      //anchors.leftMargin: units.gu(3)
                      spacing: units.gu(2)
                      anchors.fill: parent

                     /* transparent placeholder: to place the content under the header */
                     Rectangle {
                        color: "transparent"
                        width: parent.width
                        height: units.gu(6)
                     }

                     Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        Label {
                           id:userInfoTitle
                           text:i18n.tr("User informations")
                           font.bold: true
                        }
                     }


                     Row{
                        id: userNameRow
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: units.gu(1)

                        Label {
                           anchors.verticalCenter: userNameField.verticalCenter
                           text:"* "+i18n.tr("Your Name")+":"
                        }

                        TextField{
                           id: userNameField
                           x: userInfoTitle.x
                           width: units.gu(25)
                        }
                     }


                     Row{
                         id: userHeightRow
                         anchors.horizontalCenter: parent.horizontalCenter
                         spacing: units.gu(1)

                         Label {
                           anchors.verticalCenter: userHeigthField.verticalCenter
                           text:"* "+i18n.tr("Heigth")+":"
                         }

                         TextField{
                            id: userHeigthField
                            x: userInfoTitle.x
                            width: units.gu(10)
                         }

                         Label {
                           anchors.verticalCenter: userHeigthField.verticalCenter
                           text: i18n.tr("cm")
                         }

                         CheckBox {
                             id: centimeterCheckBox
                             anchors.verticalCenter: userHeigthField.verticalCenter
                             checked: false
                             onCheckedChanged: {
                                /* to have mutual exclusion */
                                if(checked){ //&& inchesCheckBox.checked)
                                   inchesCheckBox.checked = false
                                   kilogramCheckBox.checked = true
                                }
                             }
                         }

                         Label {
                           anchors.verticalCenter: userHeigthField.verticalCenter
                           text: i18n.tr("in")
                         }

                         CheckBox {
                             id: inchesCheckBox
                             anchors.verticalCenter: userHeigthField.verticalCenter
                             checked: false
                             onCheckedChanged: {
                                /* to have mutual exclusion */
                                if(checked){ //&& centimeterCheckBox.checked){
                                   centimeterCheckBox.checked = false
                                   libresCheckBox.checked = true
                                }
                             }
                         }
                     }

                     Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                       Label {
                         text: i18n.tr("Heigth is used to BMI calculation, keep updated if you grow")
                       }
                     }

                     Row{
                         id: birthdayRow
                         anchors.horizontalCenter: parent.horizontalCenter
                         spacing: units.gu(1)

                         Label {
                            anchors.verticalCenter: birthdayField.verticalCenter
                            text:"* "+i18n.tr("Date of birth")+":"
                         }

                         Button{
                            id: birthdayField
                            x: userInfoTitle.x
                            width: units.gu(25)
                            text: Qt.formatDateTime(new Date(), "dd MMMM yyyy")
                            onClicked: {
                               PopupUtils.open(popoverDatePickerComponent, birthdayField)
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

                     Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        Label {
                           id: unitOfMeasureTitle
                           text:i18n.tr("Unit of measure (keep default is not sure)")
                           font.bold: true
                        }
                     }

                     Row{
                         id: bloodPressuretRow
                         anchors.horizontalCenter: parent.horizontalCenter
                         spacing: units.gu(1)

                         Label {
                           anchors.verticalCenter: bloodPressureField.verticalCenter
                           text:"* "+i18n.tr("Blood pressure")+":"
                         }

                         TextField{
                            id: bloodPressureField
                            x: unitOfMeasureTitle.x
                            width: units.gu(20)
                            text: "mmHg"
                         }
                     }

                     Row{
                          id: weightRow
                          anchors.horizontalCenter: parent.horizontalCenter
                          spacing: units.gu(2)

                          Label {
                            id: weightLabel
                            text:"* "+i18n.tr("Weight")+": "
                          }

                          Label {
                            id: placeHolderLabel
                            text:" "
                          }

                          Label {
                            anchors.verticalCenter: weightLabel.verticalCenter
                            text: i18n.tr("Kg")
                          }

                          CheckBox {
                              id: kilogramCheckBox
                              anchors.verticalCenter: weightLabel.verticalCenter
                              checked: false
                              onCheckedChanged: {
                                 /* to have mutual exclusion */
                                 if(checked){ //&& libresCheckBox.checked)
                                    libresCheckBox.checked = false
                                    centimeterCheckBox.checked = true
                                 }
                              }
                          }

                          Label {
                            anchors.verticalCenter: weightLabel.verticalCenter
                            text: i18n.tr("lb")
                          }

                          CheckBox {
                              id: libresCheckBox
                              anchors.verticalCenter: weightLabel.verticalCenter
                              checked: false
                              onCheckedChanged: {
                                 /* to have mutual exclusion */
                                 if(checked){ // && kilogramCheckBox.checked)
                                    kilogramCheckBox.checked = false
                                    inchesCheckBox.checked = true
                                 }
                              }
                          }
                     }

                     Row{
                         id: glicemicRow
                         anchors.horizontalCenter: parent.horizontalCenter
                         spacing: units.gu(2)

                         Label {
                            anchors.verticalCenter: glicemicField.verticalCenter
                            text:"* "+i18n.tr("Glicemic unit")+":"
                         }

                         TextField{
                            id: glicemicField
                            x: unitOfMeasureTitle.x
                            width: units.gu(20)
                            text: "mmol/L"
                         }
                     }

                     Row{
                         id: commandButtonRow
                         anchors.horizontalCenter: parent.horizontalCenter
                         spacing: units.gu(1)

                         Button {
                            id:saveButton
                            text:i18n.tr("Save")
                            width: units.gu(15)
                            onClicked:{

                            if(Utility.isInputTextEmpty(userNameField.text) ||
                               Utility.isInputTextEmpty(userHeigthField.text) ||
                               Utility.isInputTextEmpty(bloodPressureField.text) ||
                               Utility.isInputTextEmpty(glicemicField.text) )
                            {
                                PopupUtils.open(missingRequiredFieldDialogue);

                             }else if(!centimeterCheckBox.checked && !inchesCheckBox.checked){
                                   PopupUtils.open(missingUnitOfMeasureDialogue);

                             }else if (!kilogramCheckBox.checked && !libresCheckBox.checked){
                                   PopupUtils.open(missingUnitOfMeasureDialogue);

                             }else{
                                   var wiegthUnitOfMeasure = libresCheckBox.checked ? "lb": "kg"
                                   var heigthUnitOfMeasure = centimeterCheckBox.checked ? "cm": "in"

                                   ConfigurationDao.insertUserInfo(manageAppPage.userId, userNameField.text, userHeigthField.text+" "+heigthUnitOfMeasure, birthdayField.text);

                                   ConfigurationDao.insertConfigurationValue('blood_pressure', 'unit_of_measure', bloodPressureField.text);
                                   ConfigurationDao.insertConfigurationValue('weight', 'unit_of_measure', wiegthUnitOfMeasure); //kg, lb
                                   ConfigurationDao.insertConfigurationValue('glicemic', 'unit_of_measure', glicemicField.text);

                                   PopupUtils.open(operationResultSuccessDialogue);

                                   settings.isFirstUse = false
                                   settings.defaultDataImported = true
                              }
                           }
                        }
                     }

                     Row{
                        anchors.horizontalCenter: parent.horizontalCenter
                        Label{
                           text: "* "+i18n.tr("Required field")
                        }
                    }
               } //col

         }//flick

         /* To show a scrolbar on the side */
        Scrollbar {
              flickableItem: manageAppPageFlickable
              align: Qt.AlignTrailing
          }
    }
