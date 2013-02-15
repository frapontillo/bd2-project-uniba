'use strict';

webApp.controller('LoginCtrl', function($scope, $timeout, UserSession, AuthHandler) {
	$scope.trying = false;
	// Memorizza la promise per la cancellazione dell'alert
	$scope.alterDismiss = undefined;

	$scope.tryLogin = function() {
		// Disabilito i componenti grafici
		$scope.trying = true;
		// Se si sta per cancellare l'alert, annullo la promessa
		if ($scope.alterDismiss) $timeout.cancel($scope.alterDismiss);
		$scope.alert = {type: 'info', msg: "Login in corso..."};
		// Eseguo il login
		UserSession.login($scope.username, $scope.password,
			function(result) {
				// Gestisco l'autorizzazione
				AuthHandler.handleAuthorized(result.authcode, result, $scope.remember);
			},
			function() {
				// Mostro il messaggio di errore
				$scope.trying = false;
				$scope.alert = {type: 'error', msg: "Dati non corretti!"};
				// Cancello l'alert dopo
				$scope.alterDismiss = $timeout(function() {
					$scope.alert = undefined;
				}, 2000);
			}
		);
	};
});
