import QtQuick 2.15
import QtPositioning
import QtLocation

Rectangle
{
    id: rightScreen

    anchors
    {
        top: parent.top
        bottom: bottomBar.top
        right : parent.right
    }

    Plugin
    {
        id: mapPlugin
        name: "osm" //
        PluginParameter {
            name: "osm.mapping.custom.host";
            value: "https://tile.openstreetmap.org/"
          }
    }

    Map
    {
        id:mapView
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(40.975592548514356, 28.727409677784028)  //
        zoomLevel: 14
        activeMapType: mapView.supportedMapTypes[mapView.supportedMapTypes.length-1]

        Image
        {
            id: lockIcon
            anchors
            {
                left:parent.left
                top: parent.top
                margins:20

            }
            width: parent.width /40
            fillMode:   Image.PreserveAspectFit
            source: (systemHandler.carLocked ? "qrc:/ui/assets/padlock.png" : "qrc:/ui/assets/padlock-unlock.png")

            MouseArea
            {
                anchors.fill: parent
                onClicked: function(){systemHandler.setCarLocked(!systemHandler.carLocked)}
            }
        }

        Text
        {
            id: dateTimeDisplay
            anchors
            {
                left:lockIcon.right
                leftMargin:40
                bottom : lockIcon.bottom
            }

            font.pixelSize: 12
            font.bold: true
            color : "black"

            text: systemHandler.currentTime
        }

        Text
        {
            id: outdoorTemparatureDisplay
            anchors
            {
                left:dateTimeDisplay.right
                leftMargin:40
                bottom : dateTimeDisplay.bottom
            }

            font.pixelSize: 12
            font.bold: true
            color : "black"

            text: systemHandler.outdoorTemp + "°F"
        }

        Text
        {
            id: userNameDisplay
            anchors
            {
                left:outdoorTemparatureDisplay.right
                leftMargin:40
                bottom : outdoorTemparatureDisplay.bottom
            }

            font.pixelSize: 12
            font.bold: true
            color : "black"

            text: systemHandler.userName
        }

        PinchHandler
                {
                    id: pinch
                    target: null
                    onActiveChanged: if (active) {
                        mapView.startCentroid = mapView.toCoordinate(pinch.centroid.position, false)
                    }
                    onScaleChanged: (delta) => {
                        mapView.zoomLevel += Math.log2(delta)
                        mapView.alignCoordinateToPoint(mapView.startCentroid, pinch.centroid.position)
                    }
                    onRotationChanged: (delta) => {
                        mapView.bearing -= delta
                        mapView.alignCoordinateToPoint(mapView.startCentroid, pinch.centroid.position)
                    }
                    grabPermissions: PointerHandler.TakeOverForbidden
                }
                WheelHandler
                {
                    id: wheel
                    // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
                    // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
                    // and we don't yet distinguish mice and trackpads on Wayland either
                    acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland"
                                     ? PointerDevice.Mouse | PointerDevice.TouchPad
                                     : PointerDevice.Mouse
                    rotationScale: 1/120
                    property: "zoomLevel"
                }
                DragHandler {
                    id: drag
                    target: null
                    onTranslationChanged: (delta) => mapView.pan(-delta.x, -delta.y)
                }
                Shortcut {
                    enabled: mapView.zoomLevel < map.maximumZoomLevel
                    sequence: StandardKey.ZoomIn
                    onActivated: mapView.zoomLevel = Math.round(mapView.zoomLevel + 1)
                }
                Shortcut {
                    enabled: mapView.zoomLevel > mapView.minimumZoomLevel
                    sequence: StandardKey.ZoomOut
                    onActivated: mapView.zoomLevel = Math.round(mapView.zoomLevel - 1)
                }

                NavigationSearchBox
                {
                    id: navSearchBox

                    width: parent.width * 1/3
                    height: parent.height * 1/15
                    anchors
                    {
                        left: lockIcon.left
                        top: lockIcon.top
                        topMargin: 30

                    }
                }
    }

    width : parent.height * 1.2
}
