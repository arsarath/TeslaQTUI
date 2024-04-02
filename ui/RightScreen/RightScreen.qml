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
        center: QtPositioning.coordinate(37.46, -122.14)  //
        zoomLevel: 14
        activeMapType: mapView.supportedMapTypes[mapView.supportedMapTypes.length-1]

        PinchHandler {
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
                WheelHandler {
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
    }

    width : parent.height * 1.2
}
