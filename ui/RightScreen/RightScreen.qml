import QtQuick 2.15
import QtLocation 5.12
import QtPositioning 5.12

Rectangle
{
    id: rightScreen

    anchors
    {
        top: parent.top
        bottom: bottomBar.top
        right : parent.right
    }

    color : "orange"
    width : parent.height * 1.2
}
