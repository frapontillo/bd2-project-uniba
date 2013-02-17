'use strict';

webApp.controller('AttivitaListCtrl', function($scope, $rootScope, Attivita) {
	$scope.attivita = {};
	$scope.cerca = '';
	$scope.page = 1;

	$scope.restartSearch = function() {
		$scope.page = 1;
		$scope.searchPage();
	};

	$scope.searchPage = function() {
		$scope.attivita = new Attivita().query($scope.cerca, $scope.page);
	};

	$scope.selectPage = function(p) {
		$scope.page = p;
		$scope.searchPage();
	};

	$scope.newUrl = function() {
		return "#" + $rootScope.mAttivita.mainUrl() + "/new";
	};

	$scope.restartSearch();
});

webApp.controller('AttivitaDetailCtrl', function($scope, $rootScope, $routeParams, $location, $dialog, Attivita) {
	// Avvio una nuova richiesta
	$scope.a = new Attivita().get($routeParams.id);

	$scope.deleteEntity = function() {
		if (!$scope.locked)
			$scope.openMessageBox();
	};

	$scope.editUrl = function() {
		return "#" + $rootScope.mAttivita.mainUrl() + "/" + $routeParams.id + "/edit";
	};

	$scope.deleteAttivita = function() {
		$scope.alert = {type:"info", msg:"Rimozione in corso..."};
		$scope.locked = true;
		$scope.a = new Attivita().delete($routeParams.id,
			function(result) {
				$scope.goToList();
			},
			function() {
				$scope.alert = {type:"error", msg:"Impossibile cancellare!"};
				$scope.locked = false;
			});
	};

	$scope.openMessageBox = function() {
		var title = 'Cancella attività';
		var msg = 'Sei sicuro di voler cancellare l\'attività ' + $scope.a.nome + "?";
		var btns = [{result:'cancel', label: 'Annulla'}, {result:'ok', label: 'OK', cssClass: 'btn-primary'}];

		$dialog.messageBox(title, msg, btns)
			.open()
			.then(function(result) {
				if (result == 'ok') $scope.deleteAttivita();
			}
		);
	};

	$scope.goToList = function() {
		$location.path($rootScope.mAttivita.mainUrl());
	}
});

webApp.controller('AttivitaEditCtrl', function($scope) {
	// TODO
});

webApp.controller('AttivitaTableCtrl', function($scope) {
	// TODO
});