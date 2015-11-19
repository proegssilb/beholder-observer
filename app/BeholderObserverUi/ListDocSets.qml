import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Window 2.2


Item {
    id: listDocSetsPage
    width: 640
    height: 480

    property alias projectName: projectName.text
    property ListModel docSets
    signal navigateBack()

    Button {
        id: backButton
        text: qsTr("Back")
        width: 50
        anchors.bottom: projectName.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity*5
        onClicked: {
            console.log("Project DocList '" + listDocSetsPage.projectName + "' requesting go back...")
            listDocSetsPage.navigateBack()
        }
    }

    Text {
        id: projectName
        anchors.top: parent.top
        anchors.topMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 25
        anchors.left: backButton.right
        anchors.leftMargin: 0
        anchors.bottom: parent.top
        anchors.bottomMargin: -40
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity*5
    }

    GridView {
        id: docSetList
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Screen.pixelDensity*5
        anchors.right: parent.right
        anchors.rightMargin: Screen.pixelDensity*10
        anchors.left: parent.left
        anchors.leftMargin: Screen.pixelDensity*10
        anchors.top: projectName.bottom
        anchors.topMargin: Screen.pixelDensity*5
        delegate: Item {
            x: 5
            height: 50
            Column {
                Rectangle {
                    width: 40
                    height: 40
                    color: colorCode
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    x: 5
                    text: name
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                }
                spacing: 5
            }
        }
        model: ListModel {
            ListElement {
                name: "Grey"
                colorCode: "grey"
            }

            ListElement {
                name: "Red"
                colorCode: "red"
            }

            ListElement {
                name: "Blue"
                colorCode: "blue"
            }

            ListElement {
                name: "Green"
                colorCode: "green"
            }
        }
        cellWidth: 70
        cellHeight: 70
    }
}

