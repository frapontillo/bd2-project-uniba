'use strict';

webApp.factory('Config', function() {
	var baseAPI = "http://localhost\\:8080/rest/api/";

	// Public API here
	return {
		baseAPI: function() {
			return baseAPI;
		}
	};
});
