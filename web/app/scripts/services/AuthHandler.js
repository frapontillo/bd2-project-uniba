'use strict';

webApp.factory('AuthHandler', function($cookieStore, $location, $rootScope) {
	var authHandler = {};
	var authcode = '';

	authHandler.getAuthcode = function() {
		return authcode || "";
	}

	authHandler.setAuthcode = function(newAuthcode) {
		authcode = newAuthcode;
	}

	// Gestisce il login di un utente, memorizzando
	// l'authcode dove opportuno e reindirizzandolo
	// all'eventuale pagina precedente.
	authHandler.handleAuthorized = function(newAuthcode, session, remember) {
		if (remember) {
			$cookieStore.put("authcode", newAuthcode);
			$cookieStore.put("username", session.user.username);
		}
		$rootScope.session = session;
		authcode = newAuthcode;
		var newPath = ($location.search() ? $location.search().return || '/' : '/');
		newPath = decodeURIComponent(newPath);
		$location.search({});
		$location.url(newPath);
		$rootScope.$emit("applicationReload");
	};

	// Gestisce il logout
	authHandler.handleLogout = function() {
		$cookieStore.remove("authcode");
		$cookieStore.remove("username");
		$rootScope.session = null;
		authcode = '';
		$location.path("/login");
	}

	// Gestisce i casi in cui l'utente non è autorizzato
	// a compiere un'operazione, reindirizzandolo alla
	// pagina di login.
	authHandler.handleUnauthorized = function() {
		if ($location.path() != "/login") {
			$cookieStore.remove("authcode");
			$cookieStore.remove("username");
			authcode = '';
			var cUrl = encodeURIComponent($location.url());
			if ($location.path() == "/logout")
				cUrl = null;
			$location.path("/login");
			if (cUrl)
				$location.search({return: cUrl});
		}
	};

	return authHandler;
});
