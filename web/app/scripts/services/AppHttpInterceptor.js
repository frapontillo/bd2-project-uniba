'use strict';

webApp.factory('AppHttpInterceptor',
	function ($q, $rootScope, $location, AuthHandler) {
		return function (promise) {
			return promise.then(function (response) {
				// Restituisco la risposta
				return response;
			}, function (response) {
				// Se l'utente non è autorizzato
				if (response.status == 401) {
					AuthHandler.handleUnauthorized();
				}
				// Restituisco l'errore
				return $q.reject(response);
			});
		};
});
