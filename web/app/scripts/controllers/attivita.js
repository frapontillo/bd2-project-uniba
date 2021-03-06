'use strict';

// Controller per la pagina principale di ricerca attività (route: /attivita).
// Gestisce i click sulla lista tramite link, non tramite click.
webApp.controller('AttivitaListPageCtrl', ['$scope', '$rootScope',
	function($scope, $rootScope) {
		$rootScope.pageTitle = "Attività";
		$scope.newUrl = function() {
			return "#" + $rootScope.mAttivita.mainUrl() + "/new";
		};
		// Reindirizza al dettaglio della struttura
		$scope.handleListLink = function(attivita) {
			return "#" + $rootScope.mAttivita.mainUrl() + "/" + attivita.id;
		};
	}
]);

// Controller per la messagebox che contiene la vista parziale.
// Gestisce i click sulla lista, non usa i link.
// dialog viene iniettata automaticamente nel controller
webApp.controller('AttivitaListDialogCtrl', ['$scope', 'dialog',
	function($scope, dialog) {
		// Chiude la dialog restituendo al chiamante l'attività
		$scope.handleListClick = function(attivita) {
			dialog.close(attivita);
		};
		$scope.closeNoResult = function() {
			dialog.close(null);
		}
	}
]);

// Controller per la vista parziale, cerca solamente i dipendenti e li mostra, non gestisce i click o i link
webApp.controller('AttivitaListCtrl', ['$scope', '$rootScope', 'Attivita',
	function($scope, $rootScope, Attivita) {
		$scope.attivita = {};
		$scope.cerca = '';
		$scope.page = 1;

		$scope.restartSearch = function() {
			$scope.page = 1;
			$scope.searchPage();
		};

		$scope.searchPage = function() {
			$scope.searching = true;
			$scope.attivita = new Attivita().query($scope.cerca, $scope.strutturaForAttivitaList, $scope.page,
				function() {
					$scope.searching = false;
				});
		};

		$scope.selectPage = function(p) {
			$scope.page = p;
			$scope.searchPage();
		};

		$scope.newUrl = function() {
			return "#" + $rootScope.mAttivita.mainUrl() + "/new";
		};

		$scope.restartSearch();
	}
]);

webApp.controller('AttivitaDetailCtrl', ['$scope', '$rootScope', '$routeParams', '$location', '$dialog', 'Attivita',
	function($scope, $rootScope, $routeParams, $location, $dialog, Attivita) {
		$rootScope.pageTitle = "Attività";
		// Avvio una nuova richiesta
		$scope.a = new Attivita().get($routeParams.id, function(a) {
			$rootScope.pageTitle = "Attività " + a.nome;
		});

		// Avviso la lista delle assunzioni di utilizzare l'ID del dipendente per eseguire la ricerca
		$scope.attivitaForAssunzioneList = $routeParams.id;
		// Avviso la lista delle assunzioni di non mostrare il dipendente ma di mostrare l'attività
		$scope.showDipendente = true;
		$scope.showAttivita = false;

		$scope.deleteEntity = function() {
			if (!$scope.locked)
				$scope.openMessageBox();
		};

		$scope.editUrl = function() {
			return "#" + $rootScope.mAttivita.mainUrl() + "/" + $routeParams.id + "/edit";
		};

		$scope.newUrl = function() {
			return "#" + $rootScope.mAssunzioni.mainUrl() + "/new?attivita=" + $routeParams.id;
		};

		$scope.handleListLink = function(assunzione) {
			return "#" + $rootScope.mAssunzioni.mainUrl() + "/" + assunzione.id;
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
	}
]);

webApp.controller('AttivitaNewEditCtrl', ['$scope', '$rootScope', '$location', '$dialog', 'Attivita', 'TipoAttivita',
	function($scope, $rootScope, $location, $dialog, Attivita, TipoAttivita) {
		$scope.triedSave = false;
		$scope.tipi = new TipoAttivita().query(null, null, function(t) {
			$scope.tipi = t;
		});

		$scope.boxManagerOpts = {
			backdrop: true,
			keyboard: true,
			backdropClick: true,
			templateUrl:  'views/_dialog_dipendente.html',
			controller: 'DipendenteListDialogCtrl'
		};

		$scope.boxStrutturaOpts = {
			backdrop: true,
			keyboard: true,
			backdropClick: true,
			templateUrl:  'views/_dialog_struttura.html',
			controller: 'StrutturaListDialogCtrl'
		};

		$scope.selectManager = function() {
			var d = $dialog.dialog($scope.boxManagerOpts);
			d.open().then(
				function(selDip) {
					if (selDip) {
						$rootScope.$emit("gotManager", selDip);
					}
				}
			);
		};

		$scope.selectStruttura = function() {
			var d = $dialog.dialog($scope.boxStrutturaOpts);
			d.open().then(
				function(selStr) {
					if (selStr) {
						$rootScope.$emit("gotStruttura", selStr);
					}
				}
			);
		};

		$scope.removeManager = function() {
			$rootScope.$emit("gotManager", undefined);
		};

		$scope.removeStruttura = function() {
			$rootScope.$emit("gotStruttura", undefined);
		};

		$scope.controlGroupStatus = function(evaluate) {
			if (!evaluate)
				return 'error';
		};

		$scope.goToList = function(id) {
			$location.path($rootScope.mAttivita.mainUrl());
		};

		$scope.goToDetail = function(id) {
			$location.path($rootScope.mAttivita.mainUrl() + '/' + id);
		};

		$scope.checkNumericOrEmpty = function(value) {
			return !value || (!isNaN(value) && parseInt(value) == value);
		};
	}
]);

webApp.controller('AttivitaEditCtrl', ['$scope', '$rootScope', '$routeParams', 'Attivita',
	function($scope, $rootScope, $routeParams, Attivita) {
		$rootScope.pageTitle = "Modifica";
		$scope.locked = true;
		$scope.alert = {type:"info", msg:"Carico l'attività..."};

		$scope.a = new Attivita().get($routeParams.id, function(a) {
			$rootScope.pageTitle = "Modifica " + a.nome;
			$scope.locked = false;
			$scope.alert = null;
		});

		$scope.save = function() {
			if (!$scope.locked) {
				$scope.$parent.triedSave = true;
				$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
				$scope.locked = true;
				// Pulisco il manager
				if ($scope.a.manager) {
					delete $scope.a.manager['$$hashKey'];
					delete $scope.a.manager['@type'];
				}
				// Pulisco la struttura
				if ($scope.a.struttura) {
					delete $scope.a.struttura['$$hashKey'];
					delete $scope.a.struttura['@type'];
				}
				$scope.a = new Attivita().put($routeParams.id, $scope.a,
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

		$rootScope.$on("gotManager", function(e, selDip) {
			$scope.a.manager = selDip;
		});

		$rootScope.$on("gotStruttura", function(e, selStr) {
			$scope.a.struttura = selStr;
			if (!$scope.a.struttura || $scope.a.struttura.tipo.codice != 'E')
				$scope.a.piano = null;
		});
	}
]);

webApp.controller('AttivitaNewCtrl', ['$scope', '$rootScope', '$location', 'Attivita', 'Struttura', 'Dipendente',
	function($scope, $rootScope, $location, Attivita, Struttura, Dipendente) {
		$rootScope.pageTitle = "Nuova attività";
		$scope.a = new Attivita();

		// Se in URL ci sono gli ID della struttura e/o del proprietario, li seleziono già
		if ($location.search().struttura) {
			$scope.a.struttura = new Struttura().get($location.search().struttura);
		}
		if ($location.search().manager) {
			$scope.a.manager = new Dipendente().get($location.search().manager);
		}

		$scope.save = function() {
			if (!$scope.locked) {
				$scope.$parent.triedSave = true;
				$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
				$scope.locked = true;
				// Pulisco il manager
				if ($scope.a.manager) {
					delete $scope.a.manager['$$hashKey'];
					delete $scope.a.manager['@type'];
				}
				// Pulisco la struttura
				if ($scope.a.struttura) {
					delete $scope.a.struttura['$$hashKey'];
					delete $scope.a.struttura['@type'];
				}
				$scope.a = new Attivita().post($scope.a,
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

		$rootScope.$on("gotManager", function(e, selDip) {
			$scope.a.manager = selDip;
		});

		$rootScope.$on("gotStruttura", function(e, selStr) {
			$scope.a.struttura = selStr;
			if (!$scope.a.struttura || $scope.a.struttura.tipo.codice != 'E')
				$scope.a.piano = null;
		});
	}
]);