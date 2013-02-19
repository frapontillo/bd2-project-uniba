'use strict';

webApp.factory('Config', function() {
	var baseAPI = "http://localhost\\:8080/rest/api/";
	var analysisPage = "http://localhost:8080/jpivot/better.jsp?query=mallAnalysis";

	// Public API here
	return {
		baseAPI: function() {
			return baseAPI;
		},
		analysisPage: function() {
			return analysisPage;
		}
	};
});
