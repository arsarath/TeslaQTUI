import QtQuick 2.15

Item {
    property string fontColor: "#f0eded"

    width: 120 * (parent.width / 1280)

    Connections
    {
        target: audioController
        function onVolumeLevelChanged()
        {
            visibleTimer.stop()
            volumeIcon.visible = false
            visibleTimer.start()

        }
    }

    Timer
    {
        id: visibleTimer
        interval: 1000
        repeat: false
        onTriggered:
        {
            volumeIcon.visible = true
        }
    }

    Rectangle
    {
        id: decrementButton
        anchors
        {
            right: volumeIcon.left
            rightMargin: 15
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
            onClicked: audioController.incrementVolume(-1)
        }
    }

    Image {
        id: volumeIcon
        height: parent.height * .5
        fillMode: Image.PreserveAspectFit
        anchors
        {
            right: incrementButton.left
            rightMargin: 15
            verticalCenter:parent.verticalCenter
        }
        source:
        {
            if(audioController.volumeLevel <= 1)
            {
                return "qrc:ui/assets/volume-mute.png"
            }
            else if(audioController.volumeLevel <= 50)
            {
                return "qrc:ui/assets/audio1.png"
            }
            else
            {
                return "qrc:ui/assets/audio2.png"
            }
        }
    }

    Text {
        id: volumeTextLabel
        visible: !volumeIcon.visible
        anchors
        {
            centerIn: volumeIcon
        }
        color: fontColor
        text: audioController.volumeLevel
        font.pixelSize: 24
    }

    Rectangle
    {
        id: incrementButton
        anchors
        {
            right: parent.right
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
            onClicked: audioController.incrementVolume(1)
        }

    }





}
