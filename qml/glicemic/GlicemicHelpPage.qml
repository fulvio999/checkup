import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

import QtQuick.LocalStorage 2.0

import "GlicemicDao.js" as GlicemicDao
import "../ConfigurationDao.js" as ConfigurationDao

import "../Utility.js" as Utility

/* import qml files from a sub-folder */
import "../commons"

/*
  GLYCEMIC MAIN PAGE for PHONE
*/
Page {
     id: glicemicPageTablet
     visible: false

     header: PageHeader {
        title: i18n.tr("Glycemic help page")
     }

     Flickable {
         id:glicemicPageTabletFlickable
         clip: true
         contentHeight: Utility.getContentHeight()
         anchors {
                 top: parent.top
                 left: parent.left
                 right: parent.right
                 bottom: glicemicPageTablet.bottom
                 bottomMargin: units.gu(2)
         }

         Column{
              id: glicemicPageColumn
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
                Label{
                   text: i18n.tr("Help dictionary") + ": IT - EN - FR - DE - ES"
                   textSize: Label.Medium
                   font.bold: true
                }
              }

              Image {
                  source: Qt.resolvedUrl("glicemicHelp.png")
                  fillMode: Image.PreserveAspectCrop
                  sourceSize.width: parent.width
                  sourceSize.height: parent.height
              }
        }

    }//flick

    /* To show a scrolbar on the side */
    Scrollbar {
        flickableItem: glicemicPageTabletFlickable
        align: Qt.AlignTrailing
    }
}
