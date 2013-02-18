'use strict';

webApp.factory('Struttura', function($resource, Config, AuthHandler) {
	var Struttura = $resource(Config.baseAPI() + 'struttura/:id', {},
		{
			_query: {method: 'GET', params: {authcode: '', codice: '', page: '1'}},
			_get: {method: 'GET', params: {authcode:'', id:''}},
			_post: {method: 'POST', params: {authcode:''}},
			_put: {method: 'PUT', params: {authcode:'', id:''}},
			_delete: {method: 'DELETE', params:{authcode:''}}
		}
	);

	Struttura.prototype.query = function(codice, page, success, fail) {
		return Struttura._query({codice:codice, page:page||'1', authcode:AuthHandler.getAuthcode()},
			function (result) {
				Struttura.prototype.fillAll(result);
				if (success && angular.isFunction(success)) success(result);
			}, fail);
	};

	Struttura.prototype.get = function(id, success, fail) {
		return Struttura._get({id:id, authcode:AuthHandler.getAuthcode()},
			function (result) {
				Struttura.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			}, fail);
	};

	Struttura.prototype.put = function(id, obj, success, fail) {
		return Struttura._put({authcode:AuthHandler.getAuthcode(), id:id}, obj,
			function (result) {
				Struttura.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			},fail);
	};

	Struttura.prototype.post = function(obj, success, fail) {
		return Struttura._post({authcode:AuthHandler.getAuthcode()}, obj,
			function (result) {
				Struttura.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			},fail);
	};

	Struttura.prototype.delete = function(id, success, fail) {
		return Struttura._delete({authcode:AuthHandler.getAuthcode(), id:id},
			function (result) {
				if (success && angular.isFunction(success)) success(result);
			},fail);
	};

	Struttura.prototype.fill = function(obj) {
		obj.cod = obj.tipo.codice + '-' + obj.id;
	};

	Struttura.prototype.fillAll = function(objects) {
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
			Struttura.prototype.fill(objects.list[obj]);
		}
	};

	return Struttura;
});
