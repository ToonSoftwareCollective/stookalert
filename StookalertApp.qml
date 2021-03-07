import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import FileIO 1.0

App {
	id: stookalertApp

	property url tileUrl : "StookalertTile.qml"
	property url thumbnailIcon: "qrc:/tsc/stookalertSmallNoBG.png"   // TODO
	
	property url stookalertScreenUrl : "StookalertScreen.qml"
	property url stookalertConfigurationScreenUrl : "StookalertConfigurationScreen.qml"
	property url stookalertProvincieScreenUrl : "StookalertProvincieScreen.qml"

	property url trayUrl : "StookalertTray.qml"

	property StookalertConfigurationScreen stookalertConfigurationScreen
	property StookalertScreen stookalertScreen
	property StookalertProvincieScreen stookalertProvincieScreen

	// settings
    property int stookalertShowTileAlertsDurationHours : 0
    property bool enableSystray : false
	property string provincie : ""

    property variant stookAlertData
	property variant provincieArray : []

	// for Tile
    property bool stookalertAlert  : false
	property bool stookalertIconShow : false
    property string tileStatus : "Wachten op data....."

	// true when data is read
	property bool stookalertDataRead : false

	property string stookalertLastUpdateTime
	property string stookalertLastResponseStatus : "N/A"
	
	// user settings from config file
	property variant stookalertSettingsJson 

	// Refresh interval in minutes
	property int stookalertRefreshIntervalMinutes : 60;
	

	property bool debugOutput : false						// Show console messages. Turn on in settings file !

    property bool debugData : false


	FileIO {
		id: stookalertSettingsFile
		source: "file:///mnt/data/tsc/stookalert.userSettings.json"
 	}


	FileIO {
		id: stookalertResponseFile
		source: "file:///tmp/stookalert-response.json"
 	}

	Component.onCompleted: {
		// read user settings

		try {
			stookalertSettingsJson = JSON.parse(stookalertSettingsFile.read());
			if (stookalertSettingsJson['TrayIcon'] == "Yes") {
				enableSystray = true
			} else {
				enableSystray = false
			}

			if (stookalertSettingsJson['DebugOn'] == "Yes") {
				debugOutput = true
			} else {
				debugOutput = false
			}

			if (stookalertSettingsJson['DebugDataOn'] == "Yes") {
				debugData = true
			} else {
				debugData = false
			}

			provincie = stookalertSettingsJson['Provincie']
		} catch(e) {
		}

		
		stookalertTimer.start();

	}

	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: "StookAlert", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", stookalertScreenUrl, this, "stookalertScreen");
		registry.registerWidget("screen", stookalertConfigurationScreenUrl, this, "stookalertConfigurationScreen");
		registry.registerWidget("screen", stookalertProvincieScreenUrl, this, "stookalertProvincieScreen");
		registry.registerWidget("systrayIcon", trayUrl, this, "stookalertTray");
	}

	function saveSettings() {
		// save user settings
		if (debugOutput) console.log("********* StookAlert saveSettings");

		var tmpTrayIcon = "";
		if (enableSystray == true) {
			tmpTrayIcon = "Yes";
		} else {
			tmpTrayIcon = "No";
		}
		
		var tmpDebugOn = "";
		if (debugOutput == true) {
			tmpDebugOn = "Yes";
		} else {
			tmpDebugOn = "No";
		}

		var tmpDebugDataOn = "";
		if (debugData == true) {
			tmpDebugDataOn = "Yes";
		} else {
			tmpDebugDataOn = "No";
		}
		

 		var tmpUserSettingsJson = {
			"Provincie"      	: provincie,
 			"TrayIcon"      	: tmpTrayIcon,
			"DebugOn"			: tmpDebugOn,
			"DebugDataOn"		: tmpDebugDataOn,
		}

		stookalertSettingsFile.write(JSON.stringify(tmpUserSettingsJson ));
	
	}

	// Get StookAlert data
    function refreshStookAlertData() {
        if (debugOutput) console.log("********* StookAlert refreshStookAlertData started");

		stookalertDataRead = false;
        tileStatus = "Ophalen gegevens.....";

		// just for debugging an reading StookAlert data from file
        if (debugData) {
			stookalertDataRead = true;
            if (debugOutput) console.log("********* StookAlert refreshStookAlertData debug on");
			tileStatus = "Debug aan.....";
			readStookAlertResponse();
			stookalertScreen.refreshButtonEnabled(true);  // Allow manual refresh
            return;
        }

		var urlPart;
		
		var now = new Date();	
		var dateToday = now.getFullYear() + ("0"+(now.getMonth()+1)).slice(-2) + ("0"+now.getDate()).slice(-2);
		if (debugOutput) console.log("********* StookAlert refreshStookAlertData dateToday: " + dateToday);

		var currentHour = now.getHours();
		
		// retrieved from RIVM website
		if (currentHour >= 3 && currentHour < 12) {
			// Use 'noalert' json file
			urlPart = "noalert";
		} else {
			// use date in json file
			urlPart = dateToday;
		}

		var url = "https://www.rivm.nl/media/lml/stookalert/stookalert_" + urlPart + ".json"
		if (debugOutput) console.log("********* StookAlert refreshStookAlertData url: " + url);

        var xmlhttp = new XMLHttpRequest();

        xmlhttp.open("GET", url, true);
		
        xmlhttp.onreadystatechange = function() {
            if (debugOutput) console.log("********* StookAlert refreshStookAlertData readyState: " + xmlhttp.readyState );
            if (xmlhttp.readyState == XMLHttpRequest.DONE) {
				if (debugOutput) console.log("********* StookAlert refreshStookAlertData http status: " + xmlhttp.status);

				stookalertLastResponseStatus = xmlhttp.status;
				stookalertDataRead = true;

//				if (debugOutput) console.log("********* StookAlert refreshStookAlertData STookAlert headers received: " + xmlhttp.getAllResponseHeaders());
//				if (debugOutput) console.log("********* StookAlert refreshStookAlertData StookAlert data received: " + xmlhttp.responseText);

				// save response
				stookalertResponseFile.write(xmlhttp.responseText);

				if (xmlhttp.status == 200) {
                    stookAlertData = JSON.parse(xmlhttp.responseText);

                    if (stookAlertData.length > 0) {
						stookalertScreen.refreshButtonEnabled(true);  // Allow manual refresh

                        if (debugOutput) console.log("********* StookAlert refreshStookAlertData stookAlertData data found");
						tileStatus = "Verwerken gegevens.....";
       					processStookAlertData();

                    } else {
                        if (debugOutput) console.log("********* StookAlert refreshStookAlertData stookAlertData data found but empty");
						tileStatus = "Gereed";
                    }


				} else {
					tileStatus = "Ophalen gegevens mislukt.....";
				}
			}
        }
        xmlhttp.send();
    }


    function processStookAlertData(){
		if (debugOutput) console.log("********* StookAlert processStookAlertData started");

        if (debugOutput) console.log("********* StookAlert processStookAlertData  results: " + stookAlertData.length);
		
		var naam;
		var waarde;
		var prvnr;
		var i;
		
		// Count for Tile
		stookalertAlert = false;
		stookalertIconShow = false;

		var now = new Date();
		stookalertLastUpdateTime = now.toLocaleString('nl-NL'); 
		
		provincieArray.length = 0;
		stookalertScreen.stookAlertListModel.clear();

        for (i = 0; i <stookAlertData.length; i++) {

            naam = stookAlertData[i]['naam'];
            waarde = stookAlertData[i]['waarde'];
            prvnr = stookAlertData[i]['prvnr'];

            if (debugOutput) console.log("********* StookAlert processStookAlertData naam:" + naam );
            if (debugOutput) console.log("********* StookAlert processStookAlertData waarde:" + waarde );
            if (debugOutput) console.log("********* StookAlert processStookAlertData prvnr:" + prvnr );
			
			provincieArray.push(naam);

			if ( naam === provincie && waarde == 1) {
				stookalertAlert = true;
				stookalertIconShow = true;
			}
			
			stookalertScreen.stookAlertListModel.append({provincie: naam,
													 status: waarde,
													 prvnr: prvnr });
			
		}

		processAfterStookAlertDetails();

    }


	function processAfterStookAlertDetails(){
		if (debugOutput) console.log("********* StookAlert processAfterStookAlertDetails started");
		
//		if (debugOutput) console.log("********* StookAlert processAfterStookAlertDetails count in model: " + stookalertScreen.stookAlertListModel.count );

        if (stookalertScreen.stookAlertListModel.count > 0) {
			tileStatus = "Gereed";
        } else {

			tileStatus = "Gereed";
		}
	}

    function readStookAlertResponse(){   // only debug
		if (debugOutput) console.log("********* StookAlert readStookAlertResponse");

		try {
			var response = stookalertResponseFile.read();
			stookAlertData = JSON.parse(response);
		} catch(e) {
		}

		processStookAlertData();
    }


	Timer {               // needed for waiting stookalertScreen is loaded an functions can be used and refresh
		id: stookalertTimer
		interval: 10000  // first update after 10 seconds
		triggeredOnStart: false
		running: false
		repeat: true
		onTriggered: {
			if (debugOutput) console.log("********* StookAlert stookalertTimer start " + (new Date().toLocaleString('nl-NL')));
			interval = stookalertRefreshIntervalMinutes * 60 * 1000;  // change interval to 60 minutes
			refreshStookAlertData();		
		}
	}
	
}

