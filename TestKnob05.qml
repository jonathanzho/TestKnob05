/*
 * "TestKnob.qml"
 *
 * A test QML app for "Knob" QML component.
 */

import QtQuick 2.5
import QtQuick.Controls 1.4

// This sub-directory contains "Knob" QML component and other ones:
import "components"

Rectangle {
    id: topLevelObj
    width: 1080
    height: width * 9 / 16

    // Making use of "Knob" QML component:
    Knob {
        id: knob
        width: parent.width / 4
        anchors.centerIn: parent

        // Configurable Knob attributes:
        // =============================
        minVal: 0
        maxVal: 100
        value: minVal
        stepSize: (maxVal - minVal) / 10
        bgColor: "lightblue"
        fgColor: "silver"
        needleColor: "red"
        iconSource: "components/Fire.png"
        iconText: "Temperature"
        range: [[0,50,"blue","orange"],[50,100,"orange","red"]]
        // ==============================
    }

    Rectangle {
        id: introText
        width: parent.width / 5
        height: parent.height / 10
        anchors.left: parent.left
        anchors.top: parent.top

        TextArea {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            text: "This is to test Knob QML component. Drag the yellow slider handle to change knob value."
        }
    }

    ExitButton {
        id: exitButton
        width: parent.width / 5
        height: parent.height / 10
        anchors.right: parent.right
        anchors.top: parent.top
    }
}

