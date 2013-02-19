'use strict';

webApp.factory('Dipendente', ['$resource', 'Config', 'AuthHandler',
	function($resource, Config, AuthHandler) {
		var Dipendente = $resource(Config.baseAPI() + 'dipendente/:id', {},
			{
				_query: {method: 'GET', params: {authcode: '', nomecognome: '', page: '1'}},
				_get: {method: 'GET', params: {authcode:'', id:''}},
				_post: {method: 'POST', params: {authcode:''}},
				_put: {method: 'PUT', params: {authcode:'', id:''}},
				_delete: {method: 'DELETE', params:{authcode:''}}
			}
		);

		Dipendente.prototype.query = function(nomecognome, page, success, fail) {
			return Dipendente._query({nomecognome:nomecognome, page:page||'1', authcode:AuthHandler.getAuthcode()},
				function (result) {
					Dipendente.prototype.fillAll(result);
					if (success && angular.isFunction(success)) success(result);
				}, fail);
		};

		Dipendente.prototype.get = function(id, success, fail) {
			return Dipendente._get({id:id, authcode:AuthHandler.getAuthcode()},
				function (result) {
					Dipendente.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				}, fail);
		};

		Dipendente.prototype.put = function(id, obj, success, fail) {
			return Dipendente._put({authcode:AuthHandler.getAuthcode(), id:id}, obj,
				function (result) {
					Dipendente.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				},fail);
		};

		Dipendente.prototype.post = function(obj, success, fail) {
			return Dipendente._post({authcode:AuthHandler.getAuthcode()}, obj,
				function (result) {
					Dipendente.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				},fail);
		};

		Dipendente.prototype.delete = function(id, success, fail) {
			return Dipendente._delete({authcode:AuthHandler.getAuthcode(), id:id},
				function (result) {
					if (success && angular.isFunction(success)) success(result);
				},fail);
		};

		Dipendente.prototype.fill = function(obj) {
			obj.data_nascita = moment(obj.data_nascita)._d;
			obj.nome_cognome = obj.cognome + " " + obj.nome;
		};

		Dipendente.prototype.fillAll = function(objects) {
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
				Dipendente.prototype.fill(objects.list[obj]);
			}
		};

		return Dipendente;
	}
]);
