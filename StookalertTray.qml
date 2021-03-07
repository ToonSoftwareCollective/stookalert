import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: stookalertSystrayIcon
	posIndex: 9000
	property string objectName: "stookalertSystray"
	visible: app.enableSystray

	onClicked: {
		stage.openFullscreen(app.stookalertScreenUrl);
	}

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "file:///qmf/qml/apps/stookalert/drawables/stookalertSmallNoBG.png"
		width: 25
		height: 25
		fillMode: Image.PreserveAspectFit

	}
}
