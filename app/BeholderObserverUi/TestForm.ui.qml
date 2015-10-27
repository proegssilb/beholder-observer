import QtQuick 2.4

Item {
    id: item1
    width: 400
    height: 400

    Column {
        id: column1
        anchors.fill: parent

        Text {
            id: headline
            height: 40
            text: qsTr("What are you working on today?")
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            wrapMode: Text.WordWrap
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }
    states: [
        State {
            name: "ProjectSelected"
        }
    ]
}

