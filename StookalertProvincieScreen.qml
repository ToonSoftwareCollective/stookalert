import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;

Screen {
	id: stookalertProvincieScreen
	screenTitle: "Selecteer uw provincie"

	onShown: {

		provincieFilterModel.clear();
		for (var i = 0; i < app.provincieArray.length; i++) {
			provincieFilterModel.append({name: app.provincieArray[i]});
		}

	}


	ControlGroup {
		id: provincieFilterGroup
		exclusive: false
	}

	GridView {
		id: provincieGridView

		model: provincieFilterModel
		delegate: ProvincieFilterDelegate {}

		interactive: false
		flow: GridView.TopToBottom
		cellWidth: isNxt ? 320 : 250
		cellHeight: isNxt ? 38 : 30

		anchors {
			fill: parent
			top: parent.top
			left: parent.left
			topMargin: 5
			leftMargin: 40
		}
	}

	ListModel {
		id: provincieFilterModel
	}
}