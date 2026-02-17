import QtQuick
import "." as Local

Text {
    property string icon: ""
    property int iconSize: Local.Theme.font.large
    font.family: "Material Symbols Rounded"
    font.pixelSize: iconSize
    text: icon
    color: Local.Theme.colors.foreground
}
