import QtQuick 2.1
import qb.components 1.0

Tile {
	id: stookalertTile

	onClicked: {
		stage.openFullscreen(app.stookalertScreenUrl);
	}

	Image {
		id: stookalertIcon1
		source: "file:///qmf/qml/apps/stookalert/drawables/stookalertTile.png"
		anchors {
			baseline: parent.top
			baselineOffset: 10
			horizontalCenter: parent.horizontalCenter
		}
		width: 100 
		height: 100
		fillMode: Image.PreserveAspectFit
		cache: false
       	visible: dimState ? app.stookalertIconShow : false	
	}

	Text {
		id: stookalertIcon1Text
		text: "Stook alert"
		anchors {
			top: stookalertIcon1.bottom
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
       	visible: dimState ? app.stookalertIconShow : false	
	}



	Text {
		id: tiletitle
		text: "Stook alert"
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 30 : 24
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
       		visible: !dimState
	}

	Text {
		id: provincieText
		text: app.provincie
		anchors {
			top: tiletitle.bottom
			topMargin: 1
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.italic.name
			pixelSize: isNxt ? 22 : 18
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
       	visible: !dimState
	}


	Text {
		id: insideAreaText
		text: (app.stookalertAlert) ? "Stookalert actief!" : "Geen stookalert actief" 
		anchors {
			top: tiletitle.bottom
			topMargin: 25
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 22 : 18
		}
		color: (app.stookalertAlert) ? "red" : "green"
       	visible: !dimState
	}


	Text {
		id: statusText
		text: "Status"
		anchors {
			bottom: txtStatus.top
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 22 : 18
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
       	visible: !dimState
	}

	Text {
		id: txtStatus
		text: app.tileStatus
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.clockTileColor : colors.clockTileColor
		anchors {
			bottom: parent.bottom
			bottomMargin: 10
			horizontalCenter: parent.horizontalCenter
		}
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.italic.name
       	visible: !dimState
	}
	
	
	
}
