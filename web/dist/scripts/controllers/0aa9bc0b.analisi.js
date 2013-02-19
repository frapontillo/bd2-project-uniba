'use strict';

webApp.controller('AnalisiCtrl', ['$scope', '$rootScope', 'Config',
	function($scope, $rootScope, Config) {
		$rootScope.pageTitle = "Analisi";
		$scope.analysisPage = Config.analysisPage();
	}
]);
