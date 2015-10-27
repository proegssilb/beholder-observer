import QtQuick 2.0

Item {
    id: control

    width: 200
    height: 200

    property alias text: title.text
    signal clicked(string text)

    Text {
        id: title
        anchors.fill: parent
        anchors.margins: 15
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 18
    }

    MouseArea {
        anchors.fill: parent
        onClicked: control.clicked(control.text)
    }
}

