'use strict';

webApp.controller('AssunzioneListCtrl', function($scope, Dipendenza) {
	$scope.assunzioni = {};
	// La ricerca testuale è disabilitata per le assunzioni
	// $scope.cerca = '';
	$scope.page = 1;

	$scope.restartSearch = function() {
		$scope.page = 1;
		$scope.searchPage();
	};

	$scope.searchPage = function() {
		$scope.searching = true;
		$scope.assunzioni = new Dipendenza().query(
			$scope.dipendenteForAssunzioneList, $scope.attivitaForAssunzioneList, $scope.page,
			function(result) {
				$scope.assunzioni = result;
				$scope.searching = false;
			}
		);
	};

	$scope.selectPage = function(p) {
		$scope.page = p;
		$scope.searchPage();
	};

	$scope.restartSearch();
});

webApp.controller('AssunzioneDetailCtrl', function($scope, $rootScope, $routeParams, $location, $dialog, Dipendenza) {
	// Avvio una nuova richiesta
	$scope.a = new Dipendenza().get($routeParams.id,
		function(a) {
			$scope.a = a;
		}
	);

	$scope.deleteEntity = function() {
		if (!$scope.locked)
			$scope.openMessageBox();
	};

	$scope.editUrl = function() {
		return "#" + $rootScope.mAssunzioni.mainUrl() + "/" + $routeParams.id + "/edit";
	};

	$scope.deleteAssunzione = function() {
		$scope.alert = {type:"info", msg:"Rimozione in corso..."};
		$scope.locked = true;
		new Dipendenza().delete($routeParams.id,
			function(result) {
				$scope.goToList();
			},
			function() {
				$scope.alert = {type:"error", msg:"Impossibile cancellare!"};
				$scope.locked = false;
			});
	};

	$scope.openMessageBox = function() {
		var title = 'Cancella assunzione';
		var msg = 'Sei sicuro di voler cancellare l\'assunzione? '
			+'Il dipendente ' + $scope.a.dipendente.cognome + ' ' + $scope.a.dipendente.nome
			+ ' non risulterà mai essere stato assunto dall\'attività ' + $scope.a.attivita.nome + '.';
		var btns = [{result:'cancel', label: 'Annulla'}, {result:'ok', label: 'OK', cssClass: 'btn-primary'}];

		$dialog.messageBox(title, msg, btns)
			.open()
			.then(function(result) {
				if (result == 'ok') $scope.deleteAssunzione();
			}
		);
	};

	$scope.goToList = function() {
		$location.path($rootScope.mDipendenti.mainUrl() + "/" + $scope.a.dipendente.id);
	}
});

webApp.controller('AssunzioneNewEditCtrl', function($scope, $rootScope, $location, $dialog, Attivita, Dipendente) {
	$scope.triedSave = false;

	$scope.boxDipendenteOpts = {
		backdrop: true,
		keyboard: true,
		backdropClick: true,
		templateUrl:  'views/_dialog_dipendente.html',
		controller: 'DipendenteListDialogCtrl'
	};

	$scope.boxAttivitaOpts = {
		backdrop: true,
		keyboard: true,
		backdropClick: true,
		templateUrl:  'views/_dialog_attivita.html',
		controller: 'AttivitaListDialogCtrl'
	};

	$scope.selectDipendente = function() {
		var d = $dialog.dialog($scope.boxDipendenteOpts);
		d.open().then(
			function(selDip) {
				if (selDip) {
					$rootScope.$emit("gotDipendente", selDip);
				}
			}
		);
	};

	$scope.selectAttivita = function() {
		var d = $dialog.dialog($scope.boxAttivitaOpts);
		d.open().then(
			function(selAtt) {
				if (selAtt) {
					$rootScope.$emit("gotAttivita", selAtt);
				}
			}
		);
	};

	$scope.controlGroupStatus = function(evaluate) {
		if (!evaluate)
			return 'error';
	};

	$scope.goToList = function(id) {
		window.history.back();
	};

	$scope.goToDetail = function(id) {
		$location.url($rootScope.mAssunzioni.mainUrl() + '/' + id);
	};

	$scope.checkNumericOrEmpty = function(value) {
		return !value || (!isNaN(value) && parseInt(value) == value);
	};
});

webApp.controller('AssunzioneEditCtrl', function($scope, $rootScope, $routeParams, Dipendenza) {
	$scope.locked = true;
	$scope.alert = {type:"info", msg:"Carico l'assunzione..."};

	// La selezione del dipendente e dell'attività sono disabilitate
	$scope.canChangeDipendente = false;
	$scope.canChangeAttivita = false;

	$scope.a = new Dipendenza().get($routeParams.id, function(a) {
		$scope.locked = false;
		$scope.alert = null;
	});

	$scope.save = function() {
		if (!$scope.locked) {
			$scope.$parent.triedSave = true;
			$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
			$scope.locked = true;
			// Pulisco il dipendente
			if ($scope.a.dipendente) {
				delete $scope.a.dipendente['$$hashKey'];
				delete $scope.a.dipendente['@type'];
			}
			// Pulisco l'attività
			if ($scope.a.attivita) {
				delete $scope.a.attivita['$$hashKey'];
				delete $scope.a.attivita['@type'];
			}
			$scope.a = new Dipendenza().put($routeParams.id, $scope.a,
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
			$scope.goToDetail($scope.a.id);
	};

	$rootScope.$on("gotDipendente", function(e, selDip) {
		$scope.a.dipendente = selDip;
	});

	$rootScope.$on("gotAttivita", function(e, selAtt) {
		$scope.a.attivita = selAtt;
	});
});

webApp.controller('AssunzioneNewCtrl', function($scope, $rootScope, $location, Attivita, Dipendente, Dipendenza) {
	$scope.a = new Dipendenza();

	// La selezione del dipendente e dell'attività sono abilitate
	$scope.canChangeDipendente = true;
	$scope.canChangeAttivita = true;

	// Se in URL ci sono gli ID della struttura e/o del proprietario, li seleziono già
	if ($location.search().attivita) {
		$scope.a.attivita = new Attivita().get($location.search().attivita);
	}
	if ($location.search().dipendente) {
		$scope.a.dipendente = new Dipendente().get($location.search().dipendente);
	}

	$scope.save = function() {
		if (!$scope.locked) {
			$scope.$parent.triedSave = true;
			$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
			$scope.locked = true;
			// Pulisco il dipendente
			if ($scope.a.dipendente) {
				delete $scope.a.dipendente['$$hashKey'];
				delete $scope.a.dipendente['@type'];
			}
			// Pulisco l'attività
			if ($scope.a.attivita) {
				delete $scope.a.attivita['$$hashKey'];
				delete $scope.a.attivita['@type'];
			}
			$scope.a = new Dipendenza().post($scope.a,
				function() {
					$scope.goToDetail($scope.a.id);
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

	$rootScope.$on("gotDipendente", function(e, selDip) {
		$scope.a.dipendente = selDip;
	});

	$rootScope.$on("gotAttivita", function(e, selAtt) {
		$scope.a.attivita = selAtt;
	});
});
