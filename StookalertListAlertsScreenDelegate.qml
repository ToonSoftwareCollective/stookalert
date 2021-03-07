import QtQuick 2.1
import BasicUIControls 1.0;

 Rectangle
{
	width:  parent.width

	Rectangle {
		id: colorBar
		height: isNxt ? 53 : 42
		width: isNxt ? 10 : 8
		anchors {
			top: parent.top
			topMargin: 3
		}
		color: (status === 0) ? "green" : "red"
	}

	
	Text {
		id: txtProvincie
		text: provincie
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name
		anchors {
			top: colorBar.top
			topMargin: 10
			left: colorBar.right
			leftMargin: 10
		}
		width: isNxt ? 200 : 140
	}

	Text {
		id: txtStatus
		text: (status === 0) ? "Ok" : "Stook alert"
		font.pixelSize:  isNxt ? 20 : 16
		font.family: qfont.regular.name
		anchors {
			top: txtProvincie.top
			left: txtProvincie.right
			leftMargin: 80
		}
	}

	Rectangle {
		id: gridLine
		height: 2
		width: parent.width - 40
		color: colors.canvas
		anchors {
			bottom: parent.bottom
			left: parent.left
		}
	}
}
