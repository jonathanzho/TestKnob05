/*
 * "Knob.qml"
 *
 * A generic QML Dial control.
 */

import QtQuick 2.5
import QtMultimedia 5.5
import QtGraphicalEffects 1.0

Rectangle {
    id: knob
    width: 500
    height: width * 3 / 2
    color: "lightgreen"

    // Configurable attributes:
    // =====================================================================================================
    property real  minVal: -1000    // knob minimum value.
    property real  maxVal: 1000    // knob maximum value. Should be greater than "minVal".
    property real  value: -1000    // knob current value, should be within the range of [minVal, maxVal].
    property real  stepSize: 100    // minimum difference between any 2 values.
    property alias bgColor: knob.color    // knob background color.
    property alias fgColor: knobSquareTop.color    // knob foreground color.
    property alias needleColor: needle.color    // needle color.
    property alias iconSource: imgIcon.source    // knob icon to indicate the purpose of the knob.
    property alias iconText: txtDesc.text    // text to describe the purpose of the knob.
    property var   range: [[-1000,0,"green","yellow"],[0,1000,"yellow","orange"]]    // value-color mapping.
    // =====================================================================================================

    property alias slider: knobSlider

    onValueChanged: {
        // Round the value to a multiple of stepSize:
        value = minVal + Math.round((value-minVal)/stepSize) * stepSize;
    }

    Rectangle {
        id: knobSlider
        width: parent.width
        height: parent.height / 20
        anchors.left: parent.left
        anchors.top: parent.top

        property real oldWidth: width

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                id: gradient
                GradientStop { position: 0.0; color: "blue" }
                GradientStop { position: 1.0; color: "red" }
            }
        }

        Component {
            id: stopComponent
            GradientStop {}
        }

        // Update slider gradient based on knob's range:
        Component.onCompleted: {
            var rangeSections = knob.range.length;
            if (rangeSections == 0) return;

            var newStops = [];

            for (var i = 0; i < rangeSections; i++) {
                var sectionValColorMap = knob.range[i];

                var v1 = sectionValColorMap[0];
                var v2 = sectionValColorMap[1];
                var c1 = sectionValColorMap[2];
                var c2 = sectionValColorMap[3];

                var p1 = (v1 - knob.minVal) / (knob.maxVal - knob.minVal);
                var p2 = (v2 - knob.minVal) / (knob.maxVal - knob.minVal);

                //                console.log(v1);
                //                console.log(v2);
                //                console.log(c1);
                //                console.log(c2);
                //                console.log(p1);
                //                console.log(p2);

                var s1 = stopComponent.createObject(knobSlider, {"position":p1,"color":c1});
                var s2 = stopComponent.createObject(knobSlider, {"position":p2,"color":c2});

                newStops.push(s1);
                newStops.push(s2);
            }

            gradient.stops = newStops;
        }

        onWidthChanged: {
            if (oldWidth != 0) {
                sliderHandle.x = width * sliderHandle.oldX / oldWidth;
                sliderHandle.oldX = sliderHandle.x;
            }

            oldWidth = width;
        }

        property alias handle: sliderHandle

        Rectangle {
            id: sliderHandle
            width: height * 2
            height: parent.height
            radius: height / 2
            color: "yellow"

            property real oldX: x

            onXChanged: {
                knob.value = knob.minVal + x * (knob.maxVal - knob.minVal) / (knob.width - width);
            }

            Audio {
                id: audioPlayer

                // ! Set up the audio first:
                source: "tone.wav"
            }

            MouseArea {
                anchors.fill: parent

                drag.target: sliderHandle
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: knobSlider.width - sliderHandle.width

                onReleased: {
                    // ! Set up the audio first:
                    audioPlayer.play();
                }
            }
        } // end of sliderHandle
    }  // end of knobSlider

    Canvas {
        id: knobScale
        width: parent.width
        height: width
        anchors.centerIn: parent
        antialiasing: true

        property color primaryColor: "orange"

        property real centerWidth: width / 2
        property real centerHeight: height / 2
        property real radius: Math.min(knobScale.width, knobScale.height) / 2.2

        property real minimumValue: 0
        property real maximumValue: 100
        property real currentValue: 33

        property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * Math.PI * 1.5

        property real angleOffset: Math.PI / 4

        signal clicked()

        onPrimaryColorChanged: requestPaint()
        onMinimumValueChanged: requestPaint()
        onMaximumValueChanged: requestPaint()
        onCurrentValueChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d");
            ctx.save();

            ctx.clearRect(0, 0, knobScale.width, knobScale.height);

            ctx.beginPath();
            ctx.lineWidth = 10;
            ctx.strokeStyle = primaryColor;
            ctx.arc(knobScale.centerWidth,
                    knobScale.centerHeight,
                    knobScale.radius,
                    angleOffset + knobScale.angle,
                    angleOffset + 2*Math.PI);
            ctx.stroke();
        }

        LinearGradient {
            anchors.fill: parent
            source: parent
            start: Qt.point(0, 0)
            end: Qt.point(width, 0)
            gradient: Gradient {
                id: grdKnobScale
                GradientStop { position: 0.0; color: "blue" }
                GradientStop { position: 1.0; color: "red" }
            }
        }

        Component {
            id: cmpStop
            GradientStop {}
        }

        // Update slider gradient based on knob's range:
        Component.onCompleted: {
            var rangeSections = knob.range.length;
            if (rangeSections == 0) return;

            var newStops = [];

            for (var i = 0; i < rangeSections; i++) {
                var sectionValColorMap = knob.range[i];

                var v1 = sectionValColorMap[0];
                var v2 = sectionValColorMap[1];
                var c1 = sectionValColorMap[2];
                var c2 = sectionValColorMap[3];

                var p1 = (v1 - knob.minVal) / (knob.maxVal - knob.minVal);
                var p2 = (v2 - knob.minVal) / (knob.maxVal - knob.minVal);

                //                console.log(v1);
                //                console.log(v2);
                //                console.log(c1);
                //                console.log(c2);
                //                console.log(p1);
                //                console.log(p2);

                var s1 = cmpStop.createObject(knobScale, {"position":p1,"color":c1});
                var s2 = cmpStop.createObject(knobScale, {"position":p2,"color":c2});

                newStops.push(s1);
                newStops.push(s2);
            }

            grdKnobScale.stops = newStops;
        }
    } // end of knobScale

    Rectangle {
        id: knobSquareBot
        width: parent.width * 3/ 4
        height: width
        radius: width / 2
        anchors.centerIn: parent
        color: knobSquareTop.color
        border.color: "lightgrey"
        //border.width: width / 40

        ConicalGradient {
            anchors.fill: knobSquareBot
            source: knobSquareBot
            gradient: Gradient {
                GradientStop { position: 0.0/8; color: knobSquareTop.color }
                GradientStop { position: 1.0/8; color: "white" }
                GradientStop { position: 2.0/8; color: knobSquareTop.color }
                GradientStop { position: 3.0/8; color: "white" }
                GradientStop { position: 4.0/8; color: knobSquareTop.color }
                GradientStop { position: 5.0/8; color: "white" }
                GradientStop { position: 6.0/8; color: knobSquareTop.color }
                GradientStop { position: 7.0/8; color: "white" }
                GradientStop { position: 8.0/8; color: knobSquareTop.color }
            }
        }

        Rectangle {
            id: knobSquareTop
            width: parent.width * 19 / 20
            height: width
            anchors.centerIn: parent
            radius: width / 2
            color: "black"
            border.color: "lightgrey"
            //border.width: width / 40

            ConicalGradient {
                anchors.fill: knobSquareTop
                source: knobSquareTop
                gradient: Gradient {
                    GradientStop { position: 0.0/8; color: "white" }
                    GradientStop { position: 1.0/8; color: knobSquareTop.color }
                    GradientStop { position: 2.0/8; color: "white" }
                    GradientStop { position: 3.0/8; color: knobSquareTop.color }
                    GradientStop { position: 4.0/8; color: "white" }
                    GradientStop { position: 5.0/8; color: knobSquareTop.color }
                    GradientStop { position: 6.0/8; color: "white" }
                    GradientStop { position: 7.0/8; color: knobSquareTop.color }
                    GradientStop { position: 8.0/8; color: "white" }
                }
            }

            Rectangle {
                id: needle
                x: width
                y: knobSquareTop.height / 2 - height / 2
                width: height
                height: knobSquareTop.height / 20
                radius: width / 2
                color: "orange"

                transform: Rotation {
                    id: needleRotation
                    origin.x: knobSquareTop.width / 2 - needle.width
                    origin.y: needle.height / 2

                    // The needle can move from 270 to -45 degrees. This angle range can also be made configurable if needed:
                    angle: -45 + (knob.value - knob.minVal) * 270 / (knob.maxVal - knob.minVal)
                }
            } // end of needle

            Text {
                id: minText
                width: parent.width / 5
                height: parent.height / 10
                anchors.left: parent.left
                anchors.bottom: parent.bottom

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: knob.minVal
            }

            Text {
                id: maxText
                width: parent.width / 5
                height: parent.height / 10
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter

                text: knob.maxVal
            }

        } // end of knobSquareTop
    } // end of knobSquareBot

    Image {
        id: imgIcon
        width: height
        height: parent.height / 10
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: txtDesc.top

        source: "Tiger.png"
    }

    Text {
        id: txtDesc
        width: parent.width
        height: parent.height / 10
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        text: "Describe the knob ..."
    }

} // end of knob
