import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3

import Ubuntu.Components.ListItems 1.3 as ListItem
import QtQuick.LocalStorage 2.0

import "../Storage.js" as Storage
import "../Utility.js" as Utility
import "WeightDao.js" as WeightDao

/* QChart.js and QChart.qml must be in the same folder of the qml file that draw the chart */
import "QChart.js" as Charts

/* Page with chart Weight movements inside a chosen time range */
Page {
     id: bloodPressureAnaliticPage
     visible: false

     header: PageHeader {
        title: i18n.tr("Weight Analytic")
     }

     /*
       DatePicker for FROM Date
      */
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

       /*
        DatePicker for TO Date
       */
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
                         /* when Datepicker is closed, is updated the date shown in the button */
                         Component.onDestruction: {
                             dateToButton.text = Qt.formatDateTime(timePicker.date, "dd MMMM yyyy")
                         }
                   }
             }
     }



     Column{
        id: bloodAnaliticColumn
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
              text: i18n.tr("Show the trend of the Weight")
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
               text: i18n.tr("Show")
               color: UbuntuColors.green
               onClicked: {
                 /* the amount of measures saved in the period */
                 var measureSaved = WeightDao.getXaxis(dateFromButton.text, dateToButton.text).length;

                 if(measureSaved === 0){ //da measure data available
                      resultSizeLabel.text = i18n.tr("NO DATA FOUND")
                      chartWeightRow.visible = false;
                      chartTitleRow.visible = true;
                      legendRow.visible = false;

                 }else{
                      weight_chart_line.chartData = WeightDao.getChartData(dateFromButton.text, dateToButton.text);
                      chartWeightRow.visible = true;
                      chartTitleRow.visible = true;
                      legendRow.visible = true;

                      resultSizeLabel.text = i18n.tr("Weight") +" - "+ i18n.tr("Found")+" "+measureSaved+" "+i18n.tr("measures")
                 }
               }
            }
        }

        /* Result row */
        Row{
          id: chartTitleRow
          anchors.horizontalCenter: parent.horizontalCenter
          visible: false
          Label{
              id: resultSizeLabel
              //text:  set at runtime
              textSize: Label.Medium
              font.bold: true
          }
        }

        /* Weight trend chart */
        Grid {
              id:chartWeightRow
              visible: false
              columns:1
              columnSpacing: units.gu(1)
              width: parent.width - units.gu(5);
              height: parent.height - units.gu(35) - legendRow.height;

              QChart {
                 id: weight_chart_line;
                 width: parent.width;
                 height: parent.height
                 chartAnimated: false;
                 chartAnimationEasing: Easing.InOutElastic;
                 chartAnimationDuration: 2000;
                 //chartData: set after the user choose time range
                 chartType: Charts.ChartType.LINE;
              }
        }

        /* Chart legend */
        Row {
              anchors.horizontalCenter: parent.horizontalCenter
              id:legendRow
              visible:false
              height: units.gu(3)
              spacing: units.gu(2)

              Text {
                 text: i18n.tr("Values are expressed using")+" "+weightPageTablet.weightUnitOfMeasure
              }
        }

   } //col


}
