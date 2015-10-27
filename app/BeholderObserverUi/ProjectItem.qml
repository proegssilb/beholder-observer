import QtQuick 2.0

Item {
    id: control
    property alias text: caption.text
    signal clicked(string text)

    width: 75
    height: 40

    Text {
        id: caption
        text: "Project Name"
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Project Item clicked: " + control.text)
            control.clicked(control.text);
        }
    }
}

