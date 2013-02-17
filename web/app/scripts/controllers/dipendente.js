'use strict';

webApp.controller('DipendenteListCtrl', function($scope, $rootScope, Dipendente) {
	$scope.dipendenti = {};
	$scope.cerca = '';
	$scope.page = 1;

	$scope.restartSearch = function() {
		$scope.page = 1;
		$scope.searchPage();
	};

	$scope.searchPage = function() {
		$scope.dipendenti = new Dipendente().query($scope.cerca, $scope.page);
	};

	$scope.selectPage = function(p) {
		$scope.page = p;
		$scope.searchPage();
	};

	$scope.newUrl = function() {
		return "#" + $rootScope.mDipendenti.mainUrl() + "/new";
	};

	$scope.restartSearch();
});

webApp.controller('DipendenteDetailCtrl', function($scope, $rootScope, $routeParams, $location, $dialog, Dipendente) {
	// Avvio una nuova richiesta
	$scope.d = new Dipendente().get($routeParams.id);

	$scope.deleteEntity = function() {
		if (!$scope.locked)
			$scope.openMessageBox();
	};

	$scope.editUrl = function() {
		return "#" + $rootScope.mDipendenti.mainUrl() + "/" + $routeParams.id + "/edit";
	};

	$scope.deleteDipendente = function() {
		$scope.alert = {type:"info", msg:"Rimozione in corso..."};
		$scope.locked = true;
		$scope.d = new Dipendente().delete($routeParams.id,
			function(result) {
				$scope.goToList();
			},
			function() {
				$scope.alert = {type:"error", msg:"Impossibile cancellare!"};
				$scope.locked = false;
			});
	};

	$scope.openMessageBox = function() {
		var title = 'Cancella dipendente';
		var msg = 'Sei sicuro di voler cancellare il dipendente ' + $scope.d.cognome + ' ' + $scope.d.nome + "?";
		var btns = [{result:'cancel', label: 'Annulla'}, {result:'ok', label: 'OK', cssClass: 'btn-primary'}];

		$dialog.messageBox(title, msg, btns)
			.open()
			.then(function(result) {
				if (result == 'ok') $scope.deleteDipendente();
			}
		);
	};

	$scope.goToList = function() {
		$location.path($rootScope.mDipendenti.mainUrl());
	}
});

webApp.controller('DipendenteNewEditCtrl', function($scope, $rootScope, $location) {
	$scope.triedSave = false;
	$scope.sessi = ["M", "F"];

	$scope.controlGroupStatus = function(evaluate) {
		if (!evaluate && $scope.triedSave)
			return 'error';
	};

	$scope.goToList = function(id) {
		$location.path($rootScope.mDipendenti.mainUrl());
	}

	$scope.goToDetail = function(id) {
		$location.path($rootScope.mDipendenti.mainUrl() + '/' + id);
	}
});

webApp.controller('DipendenteEditCtrl', function($scope, $routeParams, Dipendente) {
	$scope.locked = true;
	$scope.alert = {type:"info", msg:"Carico il dipendente..."};

	$scope.d = new Dipendente().get($routeParams.id, function(d) {
		$scope.d = d;
		$scope.locked = false;
		$scope.alert = null;
	});

	$scope.save = function() {
		if (!$scope.locked) {
			$scope.$parent.triedSave = true;
			$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
			$scope.locked = true;
			$scope.d = new Dipendente().put($routeParams.id, $scope.d,
				function() {
					$scope.goToDetail($routeParams.id);
				},
				function() {
					$scope.locked = false;
					$scope.alert = {type:"error", msg:"Errore durante il salvataggio!"};
				});
		}
	};

	$scope.cancel = function() {
		if (!$scope.locked)
			$scope.goToDetail($scope.d.id);
	};
});

webApp.controller('DipendenteNewCtrl', function($scope, $routeParams, Dipendente) {
	$scope.d = new Dipendente();

	$scope.save = function() {
		if (!$scope.locked) {
			$scope.$parent.triedSave = true;
			$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
			$scope.locked = true;
			$scope.d = new Dipendente().post($scope.d,
				function() {
					$scope.goToDetail($scope.d.id);
				},
				function() {
					$scope.locked = false;
					$scope.alert = {type:"error", msg:"Errore durante il salvataggio!"};
				}
			);
		}
	};

	$scope.cancel = function() {
		if (!$scope.locked)
			$scope.goToList();
	};
});
