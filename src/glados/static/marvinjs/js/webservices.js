// Define the default location of webservices

function getDefaultServicesPrefix() {
	var servername = "https://www.ebi.ac.uk";
	var webapp = "/chembl/api/utils";
	return servername + webapp;
}

function getDefaultServices() {
	var base = getDefaultServicesPrefix();
	var services = {
			"clean2dws" :  base + "/clean",
			//"clean3dws" : base + "/rest-v0/util/convert/clean",
			"molconvertws" : base + "/molExport",
			"stereoinfows" : base + "/cipStereoInfo",
			//"reactionconvertws" : base + "/rest-v0/util/calculate/reactionExport",
			"hydrogenizews" : base + "/hydrogenize"
	};
	return services;
}