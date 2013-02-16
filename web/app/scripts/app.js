'use strict';

var webApp = angular.module('webApp', ['ui', 'ui.bootstrap', 'ngCookies', 'ngResource']);

webApp.config(['$routeProvider', function($routeProvider) {
	$routeProvider
		.when('/', {
			templateUrl: 'views/main.html',
			templateRoute: '/',
			controller: 'MainCtrl'
		})
		.when('/struttura', {
			templateUrl: 'views/struttura_list.html',
			templateRoute: '/struttura',
			controller: 'StrutturaListCtrl'
		})
		.when('/struttura/:id', {
			templateUrl: 'views/struttura_detail.html',
			templateRoute: '/struttura/:id',
			controller: 'StrutturaDetailCtrl'
		})
		.when('/struttura/:id/edit', {
			templateUrl: 'views/struttura_list.html',
			templateRoute: '/struttura/:id/edit',
			controller: 'StrutturaEditCtrl'
		})
		.when('/attivita', {
			templateUrl: 'views/attivita_list.html',
			templateRoute: '/attivita',
			controller: 'AttivitaListCtrl'
		})
		.when('/attivita/:id', {
			templateUrl: 'views/attivita_detail.html',
			templateRoute: '/attivita/:id',
			controller: 'AttivitaDetailCtrl'
		})
		.when('/attivita/:id/edit', {
			templateUrl: 'views/attivita_list.html',
			templateRoute: '/attivita/:id/edit',
			controller: 'AttivitaEditCtrl'
		})
		.when('/dipendente', {
			templateUrl: 'views/dipendente_list.html',
			templateRoute: '/dipendente',
			controller: 'DipendenteListCtrl'
		})
		.when('/dipendente/:id', {
			templateUrl: 'views/dipendente_detail.html',
			templateRoute: '/dipendente/:id',
			controller: 'DipendenteDetailCtrl'
		})
		.when('/dipendente/:id/edit', {
			templateUrl: 'views/dipendente_list.html',
			templateRoute: '/dipendente/:id/edit',
			controller: 'DipendenteEditCtrl'
		})
		.when('/dipendenza/:id', {
			templateUrl: 'views/dipendenza_detail.html',
			templateRoute: '/dipendenza/:id',
			controller: 'DipendenzaDetailCtrl'
		})
		.when('/dipendenza/:id/edit', {
			templateUrl: 'views/dipendenza_list.html',
			templateRoute: '/dipendenza/:id/edit',
			controller: 'DipendenzaEditCtrl'
		})
		.when('/login', {
			templateUrl: 'views/login.html',
			templateRoute: '/login',
			controller: 'LoginCtrl'
		})
		.when('/logout', {
			templateUrl: 'views/logout.html',
			templateRoute: '/logout',
			controller: 'LogoutCtrl'
		})
		.otherwise({
			redirectTo: '/'
		});
	}]
);

webApp.config([
	'$httpProvider',
	function ($httpProvider) {
		$httpProvider.responseInterceptors.push('AppHttpInterceptor');
	}]
);

webApp.run(function ($rootScope, $location, $cookieStore, $routeParams, AuthHandler, Menu) {
	// Radice del menu
	$rootScope.menu = new Menu({
		name: "The Mall",
		subtitle: "Gestione centro commerciale",
		description: "Applicativo per la gestione del centro commerciale \"The Mall\".",
		url: function() { return ["/"]; }
	});

	// Elementi singoli del menu : primo livello
	$rootScope.mStrutture = new Menu({
		name: "Strutture",
		description: "Gestione delle strutture del centro commerciale. Puoi inserire una nuova struttura, "+
			"modificarne una esistente o cancellare quelle in disuso.",
		url: function() { return ["/struttura", "/struttura/" + $routeParams.id, "/struttura/" + $routeParams.id + "/edit"]; },
		menuOrder: 0
	});
	$rootScope.mAttivita = new Menu({
		name: "Attività",
		description: "Gestione delle attività presenti nel centro commerciale. "+
			"Puoi inserire attività, spostarle nelle diverse strutture, "+
			"assegnare un manager o proprietario, ecc.",
		url: function() { return ["/attivita", "/attivita/" + $routeParams.id, "/attivita/" + $routeParams.id + "/edit"]; },
		menuOrder: 1
	});
	$rootScope.mDipendenti = new Menu({
		name: "Dipendenti",
		description: "Gestione dell'anagrafica dei dipendenti, con cronologia delle assunzioni. " +
		"Possibilità di licenziare un dipendente da un'attività ed assumerlo in un'altra.",
		url: function() { return [
			"/dipendente", "/dipendente/" + $routeParams.id, "/dipendente/" + $routeParams.id + "/edit",
			"/dipendenza/" + $routeParams.id, "/dipendenza/" + $routeParams.id + "/edit"
		]; },
		menuOrder: 2
	});

	// Creo la gerarchia del menu
	$rootScope.menu.addChildren([
		$rootScope.mStrutture,
		$rootScope.mAttivita,
		$rootScope.mDipendenti
	]);

	// Funzione che restituisce la percentuale di spazio dei menu item nella index
	$rootScope.menuSpan = function() {
		var x = parseInt(12 / $rootScope.menu.children.length);
		return "span" + x;
	};

	// Funzione che restituisce il path corrente
	$rootScope.curUrl = function() {
		return $location.path();
	};

	// Configuro l'authcode e l'username iniziale
	var _authcode = $cookieStore.get("authcode") || '';
	var _username = $cookieStore.get("username") || '';
	if (_authcode && _username) {
		AuthHandler.setAuthcode(_authcode);
		$rootScope.session = {authcode:_authcode, user:{username:_username}};
	}

	// Gestione della sessione ad ogni cambiamento di route
	$rootScope.$on("$routeChangeStart", function (event, next, current) {
		if (!AuthHandler.getAuthcode()) {
			// delego la gestione del redirecting all'AuthHandler
			AuthHandler.handleUnauthorized();
		}
	});

	$rootScope.reload = function() {
		$route.reload();
	}
});