import QtQuick 2.1
import qb.components 1.0


Screen {
	id: stookalertScreen
	screenTitle: "Stook alerts per provincie"

	property alias stookAlertListModel: stookAlertModel

	function refreshButtonEnabled(enabled) {
		refreshButton.enabled = enabled;
	}


	anchors.fill: parent

	onShown: {
		if (app.debugOutput) console.log("********* StookAlert StookAlertScreen onShown");
		addCustomTopRightButton("Instellingen");

/*		
        for (var n=0; n < stookAlertModel.count; n++) {
            if (app.debugOutput) console.log("********* StookAlert stookalertScreen onShown provincie:" + stookAlertModel.get(n).provincie );
            if (app.debugOutput) console.log("********* StookAlert stookalertScreen onShown status:" + stookAlertModel.get(n).status );
            if (app.debugOutput) console.log("********* StookAlert stookalertScreen onShown prvnr:" + stookAlertModel.get(n).prvnr );
        }
*/
		
	}

	onCustomButtonClicked: {
		if (app.stookalertConfigurationScreen) app.stookalertConfigurationScreen.show();
	}

	function refreshData() {
		if (app.debugOutput) console.log("********* StookAlert refreshData");
		refreshButton.enabled = false;
		stookAlertModel.clear();
		app.stookalertLastResponseStatus = 0;  // reset otherwise wrong messages shown
		app.refreshStookAlertData();			// Refresh data
	}

	Item {
		id: header
		height: isNxt ? 55 : 45
		anchors.horizontalCenter: parent.horizontalCenter
		width: isNxt ? parent.width - 95 : parent.width - 76

		Text {
			id: headerText1
			text: "Provincie"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: header.left
				bottom: parent.bottom
			}
		}
		Text {
			id: headerText2
			text: "Status"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: headerText1.right
				leftMargin: isNxt ? 145 : 120
				bottom: parent.bottom
			}
			width: isNxt ? 100 :70
		}

		Text {
			id: headerText3
			text: "Provincie"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: headerText2.right
				leftMargin: isNxt ? 130 : 100
				bottom: parent.bottom
			}
		}
		Text {
			id: headerText4
			text: "Status"
			font.family: qfont.semiBold.name
			font.pixelSize: isNxt ? 25 : 20
			anchors {
				left: headerText3.right
				leftMargin: isNxt ? 145 : 120
				bottom: parent.bottom
			}
			width: isNxt ? 100 :70
		}

		IconButton {
			id: refreshButton
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			leftClickMargin: 3
			bottomClickMargin: 5
			iconSource: "qrc:/tsc/refresh.svg"
			onClicked: {
				// Get new Telegram data
				refreshData();
			}
		}
	}


	Rectangle {
		id: gridBack
//		height: isNxt ? 480 : 384
		width: isNxt ? 984 : 760
		anchors {
			top: header.bottom
			topMargin: isNxt ? 35 : 26
			left: parent.left
			leftMargin: 20
			bottom: footer.top
			bottomMargin: 20
		}
       		visible: true
	}

	GridView {
		id: stookAlertListView

		model: 	stookAlertModel
		delegate: StookalertListAlertsScreenDelegate {}
		cellWidth: gridBack.width / 2
		cellHeight: isNxt ? 60 : 48

		interactive: false
		flow: GridView.FlowLeftToRight 

		anchors {
			fill: gridBack
		}
	
	}

	Text {
		id: footer
		text: "Laatste gelukte update van: " + ((app.stookalertLastUpdateTime.length == 0 ) ? "N/A" : app.stookalertLastUpdateTime) + ". Verversing elke " + app.stookalertRefreshIntervalMinutes + " minuten. Laatste responscode: " + app.stookalertLastResponseStatus
		anchors {
			baseline: parent.bottom
			baselineOffset: -5
			right: parent.right
			rightMargin: 15
		}
		font {
			pixelSize: isNxt ? 18 : 15
			family: qfont.italic.name
		}
	}

    ListModel {
            id: stookAlertModel
    }

}
