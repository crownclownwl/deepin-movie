import QtQuick 2.1
import QtMultimedia 5.0
import QtGraphicalEffects 1.0

RectWithCorner {
    id: preview
    state: "normal"
    cornerPos: 89
    withBlur: false
    blurWidth: 2

    onVisibleChanged: player_loader.active = visible

    property url source: ""
    property real widthHeightScale
    property int previewPadding: 4

    property alias video: player_loader.item

    states: [
        State {
            name: "normal"
            PropertyChanges { 
                target: preview
                rectWidth: 178
                rectHeight: (rectWidth - previewPadding * 2) / widthHeightScale + previewPadding * 2 + preview.cornerHeight 
            }
            PropertyChanges { target: player_loader; active: true }
            PropertyChanges { target: time_bg; color: "#DD000000" }
        },
        State {
            name: "minimal"
            PropertyChanges { target: preview; rectWidth: 100; rectHeight: 44 }
            PropertyChanges { target: player_loader; visible: false }
            PropertyChanges { target: time_bg; color: "transparent" }
        }        
    ]
    
    function seek(percentage) {
        video.seek(Math.floor(movieInfo.movie_duration * percentage))
        videoTime.text = formatTime(movieInfo.movie_duration * percentage)
    }

    function flipHorizontal() { video.flipHorizontal() }
    function flipVertical() { video.flipVertical() }
    function rotateClockwise() { video.rotateClockwise() }
    function rotateAnticlockwise() { video.rotateAnticlockwise() }

    Component {
        id: player_component

        Player {
            autoPlay: true
            muted: true
            source: preview.source
            isPreview: true
            
            onPlaying: pause()
        }
    }

    Loader {
        id: player_loader
        sourceComponent: player_component

        anchors.fill: parent
        anchors.topMargin: previewPadding
        anchors.bottomMargin: previewPadding + preview.cornerHeight
        anchors.leftMargin: previewPadding
        anchors.rightMargin: previewPadding
    }
    
    Rectangle {
        id: time_bg
        height: 24
        anchors.bottom: player_loader.bottom
        anchors.left: player_loader.left
        anchors.right: player_loader.right
        
        Text {
            id: videoTime
            color: "white"
            anchors.centerIn: parent
        }
    }
}
