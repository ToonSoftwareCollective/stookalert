import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;

Screen {
	id: stookalertConfigurationScreen
	screenTitle: "Instellingen StookAlert app"

	property string qrCodeID

	onShown: {
		addCustomTopRightButton("Opslaan");
		enableSystrayToggle.isSwitchedOn = app.enableSystray;
		provincieLabel.inputText = app.provincie;
	}

	onCustomButtonClicked: {
		app.saveSettings();
		hide();
		app.stookalertScreen.refreshData();
	}

    onHidden: {
        }


	EditTextLabel4421 {
		id: provincieLabel
		width: isNxt ? 450 : 380
		height: isNxt ? 45 : 35
		leftText: "Uw provincie:"
		leftTextAvailableWidth: isNxt ?  175 : 140

		anchors {
			left: parent.left
			leftMargin: 40
			top: parent.top
			topMargin: 30
		}

		onClicked: {
  	              if (app.stookalertProvincieScreen) {
  	                     app.stookalertProvincieScreen.show();
  	              }

		}
	}

	IconButton {
		id: provincieButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: provincieLabel.right
			leftMargin: 6
			top: provincieLabel.top
		}

		topClickMargin: 3
		onClicked: {
 	              if (app.stookalertProvincieScreen) {
  	                     app.stookalertProvincieScreen.show();
  	              }

		}
	}


	Text {
		id: enableSystrayLabel
		width: isNxt ? 200 : 160
		height: isNxt ? 45 : 36
		text: "Icon in systray"
		font.family: qfont.semiBold.name
		font.pixelSize: isNxt ? 25 : 20
		anchors {
			left: provincieLabel.left
			top: provincieLabel.bottom
			topMargin: 6		}
	}
	
	OnOffToggle {
		id: enableSystrayToggle
		height: isNxt ? 45 : 36
		anchors.left: enableSystrayLabel.right
		anchors.leftMargin: 10
		anchors.top: enableSystrayLabel.top
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.enableSystray = true;
			} else {
				app.enableSystray = false;
			}
		}
	}




}
