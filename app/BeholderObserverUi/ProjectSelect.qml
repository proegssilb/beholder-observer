import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

Item {
    id: control

    Text {
        id: headline
        text: "What are you working on today?"
        wrapMode: Text.WordWrap
        anchors.right: parent.right
        anchors.rightMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        verticalAlignment: Text.AlignVCenter
        anchors.top: parent.top
        anchors.topMargin: 15
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 21
    }

    signal clicked(string projectName)

    ScrollView {
        id: projectListScrollView
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: headline.bottom
        anchors.topMargin: 0
        ListView {
            id: projectList
            anchors.top: parent.bottom
            anchors.topMargin: 15
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 30
            delegate: ProjectItem {
                text: name
                onClicked: control.clicked(text)
            }
            model: ListModel {
                ListElement {
                    name: "Infinity IDE"
                }

                ListElement {
                    name: "Genealogy"
                }

                ListElement {
                    name: "Virtual Reality OS"
                }

                ListElement {
                    name: "Weary Examiner"
                }

                ListElement {
                    name: "Document DB"
                }

                ListElement {
                    name: "Website"
                }

                ListElement {
                    name: "Kanban Boards"
                }

                ListElement {
                    name: "PipeLang"
                }

                ListElement {
                    name: "BI System"
                }

                ListElement {
                    name: "DDoS-resistant Web Server"
                }

                ListElement {
                    name: "FPGA Network stack"
                }
            }
        }
    }
}

