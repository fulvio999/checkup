import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

import QtQuick.LocalStorage 2.0

import "MyDoctorInfoDao.js" as MyDoctorInfoDao
import "../Utility.js" as Utility

/* import qml files from a sub-folder */
import "../commons"

/*
  MyDoctor MAIN PAGE for TABLET
*/
Page {
     id: myDoctorPageTablet
     visible: false

     header: PageHeader {
        title: i18n.tr("My Doctor")
     }

     Component.onCompleted:{
       //load my doctor saved info
       var myDoctorInfo = MyDoctorInfoDao.loadMyDoctorInfo();

       if(myDoctorInfo !== "N/A"){
           nameField.text = myDoctorInfo.item(0).name;
           surnameField.text = myDoctorInfo.item(0).surname;
           phoneField.text = myDoctorInfo.item(0).phone;
           mobileField.text = myDoctorInfo.item(0).mobile;
           emailField.text = myDoctorInfo.item(0).email;
           addressField.text = myDoctorInfo.item(0).address;
           notesTextArea.text = myDoctorInfo.item(0).notes;
       }
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

     Flickable {
           id: myDoctorPageTabletFlickable
           clip: true
           contentHeight: Utility.getContentHeight()
           anchors {
                 top: parent.top
                 left: parent.left
                 right: parent.right
                 bottom: myDoctorPageTablet.bottom
                 bottomMargin: units.gu(2)
           }

           Column{
                 id: myDoctorPageColumn
                 spacing: units.gu(1.5)
                 anchors.fill: parent

                 /* transparent placeholder: to place the content under the header */
                 Rectangle {
                     color: "transparent"
                     width: parent.width
                     height: units.gu(5)
                 }

                 Row{
                    id: titleRow
                    anchors.horizontalCenter: parent.horizontalCenter

                    Label{
                        id: titleLabel
                        textSize: Label.Large
                        text: i18n.tr("My personal doctor contacts")
                    }
                 }

                 Row{
                     id: nameRow
                     anchors.horizontalCenter: parent.horizontalCenter

                     TextField{
                         id: nameField
                         width: units.gu(25)
                         enabled:true
                         placeholderText: "* "+i18n.tr("Name")
                     }
                }

                 Row{
                     id:surnameRow
                     anchors.horizontalCenter: parent.horizontalCenter

                     TextField{
                         id: surnameField
                         width: units.gu(25)
                         enabled:true
                         placeholderText: "* "+i18n.tr("Surname")
                     }
                 }

                 Row{
                     anchors.horizontalCenter: parent.horizontalCenter
                     spacing:units.gu(2)

                     TextField{
                         id: phoneField
                         width: units.gu(25)
                         enabled:true
                         placeholderText: i18n.tr("Phone")
                     }
                 }


                 Row{
                     anchors.horizontalCenter: parent.horizontalCenter

                     TextField{
                         id: mobileField
                         width: units.gu(25)
                         enabled:true
                         placeholderText: i18n.tr("Mobile")
                     }
                 }

                 Row{
                     anchors.horizontalCenter: parent.horizontalCenter

                     TextField{
                         id: emailField
                         width: units.gu(25)
                         enabled:true
                         placeholderText: i18n.tr("Email")
                     }
                 }


                 Row{
                     anchors.horizontalCenter: parent.horizontalCenter

                     TextArea {
                         id: addressField
                         textFormat:TextEdit.AutoText
                         height: units.gu(15)
                         width: units.gu(25)
                         readOnly: false
                         placeholderText: i18n.tr("Address")
                     }
                 }

                  //------------ Notes -------------
                  Row{
                     id: notesRow
                     anchors.horizontalCenter: parent.horizontalCenter

                     TextArea {
                         id: notesTextArea
                         textFormat:TextEdit.AutoText
                         height: units.gu(12)
                         width: myDoctorPageTablet.width - units.gu(5)
                         readOnly: false
                         placeholderText: i18n.tr("Notes")
                     }
                 }


                 /* -------------- Insert Row ------------- */
                 Row{
                     id: insertRow
                     anchors.horizontalCenter: parent.horizontalCenter
                     spacing: units.gu(3)
                     Button {
                        id: saveDoctorInfoButton
                        width: units.gu(20)
                        text: i18n.tr("Save")
                        color: UbuntuColors.green
                        onClicked: {
                           /* value must be present and numeric */
                           var isNameValid = Utility.isInputTextEmpty(nameField.text);
                           var isSurnameValid = Utility.isInputTextEmpty(surnameField.text);

                           if(isNameValid || isSurnameValid){
                               PopupUtils.open(invalidInputDialogue);

                           }else{
                               var result = MyDoctorInfoDao.insertDoctorInfo(nameField.text, surnameField.text, phoneField.text, mobileField.text, emailField.text, addressField.text, notesTextArea.text);
                               if(result){
                                   PopupUtils.open(operationResultSuccessDialogue);
                               }else{
                                   PopupUtils.open(operationResultFailureDialogue);
                               }
                             }

                           }
                        }
                     }
           }

   }//flick

   /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: myDoctorPageTabletFlickable
        align: Qt.AlignTrailing
    }
}
