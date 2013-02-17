'use strict';

// Controller per la pagina principale di ricerca dipendenti (route: /dipendente).
// Gestisce i click sulla lista tramite link, non tramite click.
webApp.controller('DipendenteListPageCtrl', function($scope, $rootScope) {
	$scope.newUrl = function() {
		return "#" + $rootScope.mDipendenti.mainUrl() + "/new";
	};
	// Reindirizza al dettaglio del dipendente
	$scope.handleListLink = function(dipendente) {
		return "#" + $rootScope.mDipendenti.mainUrl() + "/" + dipendente.id;
	};
});

// Controller per la messagebox che contiene la vista parziale.
// Gestisce i click sulla lista, non usa i link.
// dialog viene iniettata automaticamente nel controller
webApp.controller('DipendenteListDialogCtrl', function($scope, dialog) {
	// Chiude la dialog restituendo al chiamante il dipendente
	$scope.handleListClick = function(dipendente) {
		dialog.close(dipendente);
	};
	$scope.closeNoResult = function() {
		dialog.close(null);
	}
});

// Controller per la vista parziale, cerca solamente i dipendenti e li mostra, non gestisce i click o i link
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
		//if (!evaluate && $scope.triedSave)
		if (!evaluate)
			return 'error';
	};

	$scope.goToList = function(id) {
		$location.path($rootScope.mDipendenti.mainUrl());
	};

	$scope.goToDetail = function(id) {
		$location.path($rootScope.mDipendenti.mainUrl() + '/' + id);
	};
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
		// TODO: controllare validità del form
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
		// TODO: controllare validità del form
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
