import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3


/* Notify an operation executed result using the input message value */
Dialog {
    id: operationResultDialog
    /* the message to display */
    property string msg;
    title: i18n.tr("Operation Result")
    //contentWidth: units.gu(40)

    Label{
        text: msg
        color: UbuntuColors.green
    }

    Button {
       text: i18n.tr("Close")
       onClicked:
          PopupUtils.close(operationResultDialog)
    }
}
