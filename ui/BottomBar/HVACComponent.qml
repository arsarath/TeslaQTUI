import QtQuick 2.15

Item {
    property string fontColor: "#f0eded"
    property var hvacController

    width: 90 * (parent.width / 1280)

    Rectangle
    {
        id: decrementButton
        anchors
        {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }

        width: height / 2
        color: "black"
        Text {
            id: decrementText
            color : fontColor
            anchors.centerIn: parent
            text: "<"
            font.pixelSize: 24
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked: hvacController.incrementTargetTemparature(-1)
        }
    }

    Text {
        id: targetTemparatureText
        anchors
        {
            left: decrementButton.right
            verticalCenter:parent.verticalCenter
        }
        color: fontColor
        text: hvacController.targetTemparature
        font.pixelSize: 24
    }

    Rectangle
    {
        id: incrementButton
        anchors
        {
            left: targetTemparatureText.right
            leftMargin: 1
            top:parent.top
            bottom: parent.bottom
        }

        width: height / 2
        color: "black"

        Text {
            id: incrementText
            color : fontColor
            anchors.centerIn: parent
            text: ">"
            font.pixelSize: 24
        }

        MouseArea
        {
            anchors.fill: parent
            onClicked: hvacController.incrementTargetTemparature(1)
        }

    }





}
