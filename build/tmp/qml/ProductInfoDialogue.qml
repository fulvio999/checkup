import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* General info about the application */
Dialog {
       id: aboutProductDialogue
       title: i18n.tr("Product Info")
       text: "Checkup version "+root.appVersion+"<br/>"+ i18n.tr("A personal health daily recorder.")+" <br/>"+i18n.tr("Author")+": fulvio"

       Button {
           text: "Close"
           onClicked: PopupUtils.close(aboutProductDialogue)
       }
}
