'use strict';

webApp.factory('Attivita', function($resource, Config, AuthHandler) {
	var Attivita = $resource(Config.baseAPI() + 'attivita/:id', {},
		{
			_query: {method: 'GET', params: {authcode: '', nome: '', struttura: '', page: '1'}},
			_get: {method: 'GET', params: {authcode:'', id:''}},
			_post: {method: 'POST', params: {authcode:''}},
			_put: {method: 'PUT', params: {authcode:'', id:''}},
			_delete: {method: 'DELETE', params:{authcode:''}}
		}
	);

	Attivita.prototype.query = function(nome, struttura, page, success, fail) {
		return Attivita._query({nome:nome, struttura:struttura||'', page:page||'1', authcode:AuthHandler.getAuthcode()},
			function (result) {
				Attivita.prototype.fillAll(result);
				if (success && angular.isFunction(success)) success(result);
			}, fail);
	};

	Attivita.prototype.get = function(id, success, fail) {
		return Attivita._get({id:id, authcode:AuthHandler.getAuthcode()},
			function (result) {
				Attivita.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			}, fail);
	};

	Attivita.prototype.put = function(id, obj, success, fail) {
		return Attivita._put({authcode:AuthHandler.getAuthcode(), id:id}, obj,
			function (result) {
				Attivita.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			},fail);
	};

	Attivita.prototype.post = function(obj, success, fail) {
		return Attivita._post({authcode:AuthHandler.getAuthcode()}, obj,
			function (result) {
				Attivita.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			},fail);
	};

	Attivita.prototype.delete = function(id, success, fail) {
		return Attivita._delete({authcode:AuthHandler.getAuthcode(), id:id},
			function (result) {
				if (success && angular.isFunction(success)) success(result);
			},fail);
	};

	Attivita.prototype.fill = function(obj) {
		obj.franchising = (obj.franchising == "true" || obj.franchising == true);
		if (obj.manager) {
			obj.manager.nome_cognome = obj.manager.cognome + " " + obj.manager.nome;
		}
	};

	Attivita.prototype.fillAll = function(objects) {
		// Se non è un array
		if (!angular.isArray(objects)) {
			// Se la lista interna non è un array la trasformo in un array
			if (objects.list && !angular.isArray(objects.list)) {
				objects.list = [objects.list];
			}
			// Gestisco i numeri di pagina
			if (objects.pages) objects.pages = parseInt(objects.pages);
			if (objects.page) objects.page = parseInt(objects.page);
		}
		if (!objects.list) return;
		for (var obj in objects.list) {
			Attivita.prototype.fill(objects.list[obj]);
		}
	};

	return Attivita;
});
