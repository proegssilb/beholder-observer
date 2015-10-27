import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

ApplicationWindow {
    id: projectMenu
    visible: true
    width: 640
    height: 480
    color: qsTr("#ffffff")
    title: qsTr("Beholder Observer")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    MessageDialog {
        id: messageDialog
        title: qsTr("May I have your attention, please?")

        function show(caption) {
            messageDialog.text = caption;
            messageDialog.open();
        }
    }

    Item {
        anchors.fill: parent
        id: uiRoot

        ProjectSelect {
            id: projSel
            z: 10
            anchors.fill: parent
            opacity: 1.0
            onClicked: {
                docSetList.projectName = projectName
                uiRoot.state = "docList"
            }
        }

        ListDocSets {
            id: docSetList
            anchors.fill: parent
            opacity: 0.0
            z: 5
            onNavigateBack: uiRoot.state = ""
        }

        states: [
            State {
                name: "docList"
                PropertyChanges {
                    target: projSel
                    opacity: 0.0
                    z: 5
                }
                PropertyChanges {
                    target: docSetList
                    opacity: 1.0
                    z: 10
                }
            }

        ]
    }

//    StackView {
//        id: pageStack
//        initialItem: ProjectSelect {
//            id: projectSelect
//            anchors.fill: parent

//        }

//        ListDocSets {
//            id: docSetList
//            anchors.fill: parent
//        }
//    }
}

