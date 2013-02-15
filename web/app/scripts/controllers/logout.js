'use strict';

webApp.controller('LogoutCtrl', function($scope, $timeout, UserSession, AuthHandler) {
	// Funzione da eseguire dopo il logout, reindirizza alla home
	$scope.afterLogout = function() {
		$scope.alert = {type:"success", msg:"Uscita eseguita con successo. Ridireziono alla pagina di login..."};
		$timeout(function() {
			AuthHandler.handleLogout();
		}, 1000);
	};

	// Eseguo il logout
	UserSession.logout(AuthHandler.getAuthcode(), $scope.afterLogout, $scope.afterLogout);
	// Mostro l'alert
	$scope.alert = {type:"info", msg:"Uscita in corso..."};
});
