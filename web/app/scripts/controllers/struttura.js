'use strict';

webApp.controller('StrutturaListCtrl', function($scope, $rootScope, Struttura) {
	$scope.strutture = {};
	$scope.cerca = '';
	$scope.page = 1;

	$scope.restartSearch = function() {
		$scope.page = 1;
		$scope.searchPage();
	};

	$scope.searchPage = function() {
		$scope.strutture = new Struttura().query($scope.cerca, $scope.page);
	};

	$scope.selectPage = function(p) {
		$scope.page = p;
		$scope.searchPage();
	};

	$scope.newUrl = function() {
		return "#" + $rootScope.mStrutture.mainUrl() + "/new";
	};

	$scope.restartSearch();
});

webApp.controller('StrutturaDetailCtrl', function($scope, $rootScope, $routeParams, $location, $dialog, Struttura) {
	// Avvio una nuova richiesta
	$scope.s = new Struttura().get($routeParams.id);

	$scope.deleteEntity = function() {
		if (!$scope.locked)
			$scope.openMessageBox();
	};

	$scope.editUrl = function() {
		return "#" + $rootScope.mStrutture.mainUrl() + "/" + $routeParams.id + "/edit";
	};

	$scope.deleteStruttura = function() {
		$scope.alert = {type:"info", msg:"Rimozione in corso..."};
		$scope.locked = true;
		$scope.s = new Struttura().delete($routeParams.id,
		function(result) {
			$scope.goToList();
		},
		function() {
			$scope.alert = {type:"error", msg:"Impossibile cancellare!"};
			$scope.locked = false;
		});
	};

	$scope.openMessageBox = function() {
		var title = 'Cancella struttura';
		var msg = 'Sei sicuro di voler cancellare la struttura ' + $scope.s.cod + "?";
		var btns = [{result:'cancel', label: 'Annulla'}, {result:'ok', label: 'OK', cssClass: 'btn-primary'}];

		$dialog.messageBox(title, msg, btns)
			.open()
			.then(function(result) {
				if (result == 'ok') $scope.deleteStruttura();
			}
		);
	};

	$scope.goToList = function() {
		$location.path($rootScope.mStrutture.mainUrl());
	}
});

webApp.controller('StrutturaNewEditCtrl', function($scope, $rootScope, $location, TipoStruttura) {
	$scope.triedSave = false;

	$scope.tipi = new TipoStruttura().query(null, null, function(s) {
		$scope.tipi = s;
	});

	$scope.controlGroupStatus = function(evaluate) {
		if (!evaluate && $scope.triedSave)
			return 'error';
	};

	$scope.goToList = function(id) {
		$location.path($rootScope.mStrutture.mainUrl());
	}

	$scope.goToDetail = function(id) {
		$location.path($rootScope.mStrutture.mainUrl() + '/' + id);
	}
});

webApp.controller('StrutturaEditCtrl', function($scope, $routeParams, Struttura) {
	$scope.locked = true;
	$scope.alert = {type:"info", msg:"Carico la struttura..."};

	$scope.s = new Struttura().get($routeParams.id, function(s) {
		$scope.s = s;
		$scope.locked = false;
		$scope.alert = null;
	});

	$scope.save = function() {
		if (!$scope.locked) {
			$scope.$parent.triedSave = true;
			$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
			$scope.locked = true;
			$scope.s = new Struttura().put($routeParams.id, $scope.s,
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
			$scope.goToDetail($scope.s.id);
	};
});

webApp.controller('StrutturaNewCtrl', function($scope, Struttura) {
	$scope.s = new Struttura();

	$scope.save = function() {
		if (!$scope.locked) {
			$scope.$parent.triedSave = true;
			$scope.alert = {type:"info", msg:"Salvataggio in corso..."};
			$scope.locked = true;
			$scope.s = new Struttura().post($scope.s,
				function() {
					$scope.goToDetail($scope.s.id);
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
