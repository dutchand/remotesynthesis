import BuilderUpdater.BuilderUpdaterService;

component  output="false"
{
	public boolean function onApplicationStart() output="false"
	{
		// read the settings
		local.iniPath = ExpandPath("settings.ini");
		local.currentVersion = trim(GetProfileString(local.iniPath,"main","version"));
		local.urlToCheck = trim(GetProfileString(local.iniPath,"main","urlToCheck"));
		local.riaForgeProjectName = trim(GetProfileString(local.iniPath,"main","riaForgeProjectName"));
		local.lastDateChecked = trim(GetProfileString(local.iniPath,"main","lastDateChecked"));
		
		// read in the settings from the xml config
		local.ide_config = fileRead(expandPath("../ide_config.xml"));
		local.ide_config = xmlParse(local.ide_config);
		
		if (isNumeric(local.ide_config.application.version.xmlText)) {
			local.currentVersion = local.ide_config.application.version.xmlText;
			SetProfileString(local.iniPath,"main","version",local.currentVersion);
		}
		
		application.builderUpdaterService = new BuilderUpdaterService(local.currentVersion,local.urlToCheck,local.riaForgeProjectName,local.lastDateChecked); 
		
		SetProfileString(local.iniPath,"main","lastDateChecked",application.builderUpdaterService.getLastDateChecked());
		
		return true;
	}
	
	public void function onRequest(
		required string targetPage) output="true"
	{
		if (structKeyExists(url,"reload")) {
			onApplicationStart();
		}
		
		if (structKeyExists(url,"downloadUpdate") && url.downloadUpdate == true) {
			// do the download and install
			application.builderUpdaterService.downloadUpdate();
			
			// display the complete form. cleanup is done on the next time the extension is opened
			application.builderUpdaterService.displayUpdateComplete();
		}
		else if (structKeyExists(url,"downloadUpdate") && url.downloadUpdate == false) {
			application.builderUpdaterService.setLastDateChecked(now());
			local.iniPath = ExpandPath("settings.ini");
			SetProfileString(local.iniPath,"main","lastDateChecked",application.builderUpdaterService.getLastDateChecked());
			// proceed with the extension as normal
		}
		// if we've never checked or if x time has passed, check for a new version
		else if (application.builderUpdaterService.isNewVersionAvailable()) {
			application.builderUpdaterService.displayUpdateForm();
		}
	}
}