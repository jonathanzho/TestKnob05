/*
 * "ExitButton.qml"
 *
 * A button that, when pressed, will exit the Qt application.
 */

import QtQuick 2.5

Rectangle {
    id: exitButton
    width: 100
    height: width
    border.color: "red"

    Text {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "Press me to exit the app."
    }

    MouseArea {
        anchors.fill: parent

        onClicked: {
            Qt.quit();
        }
    }
}
