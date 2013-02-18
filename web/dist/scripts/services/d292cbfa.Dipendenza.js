'use strict';

webApp.factory('Dipendenza', ['$resource', 'Config', 'AuthHandler', 'Dipendente',
	function($resource, Config, AuthHandler, Dipendente) {
		var Dipendenza = $resource(Config.baseAPI() + 'dipendenza/:id', {},
			{
				_query: {method: 'GET', params: {authcode: '', dipendente: '', attivita: '', page: '1'}},
				_get: {method: 'GET', params: {authcode:'', id:''}},
				_post: {method: 'POST', params: {authcode:''}},
				_put: {method: 'PUT', params: {authcode:'', id:''}},
				_delete: {method: 'DELETE', params:{authcode:'', id:''}}
			}
		);

		Dipendenza.prototype.query = function(dipendente, attivita, page, success, fail) {
			return Dipendenza._query({dipendente:dipendente||'', attivita:attivita||'',
					page:page||'1', authcode:AuthHandler.getAuthcode()},
				function (result) {
					Dipendenza.prototype.fillAll(result);
					if (success && angular.isFunction(success)) success(result);
				}, fail);
		};

		Dipendenza.prototype.get = function(id, success, fail) {
			return Dipendenza._get({id:id, authcode:AuthHandler.getAuthcode()},
				function (result) {
					Dipendenza.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				}, fail);
		};

		Dipendenza.prototype.put = function(id, obj, success, fail) {
			return Dipendenza._put({authcode:AuthHandler.getAuthcode(), id:id}, obj,
				function (result) {
					Dipendenza.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				},fail);
		};

		Dipendenza.prototype.post = function(obj, success, fail) {
			return Dipendenza._post({authcode:AuthHandler.getAuthcode()}, obj,
				function (result) {
					Dipendenza.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				},fail);
		};

		Dipendenza.prototype.delete = function(id, success, fail) {
			return Dipendenza._delete({authcode:AuthHandler.getAuthcode(), id:id},
				function (result) {
					if (success && angular.isFunction(success)) success(result);
				},fail);
		};

		Dipendenza.prototype.fill = function(obj) {
			obj.data_assunzione = obj.data_assunzione ? moment(obj.data_assunzione)._d : undefined;
			obj.data_licenziamento = obj.data_licenziamento ? moment(obj.data_licenziamento)._d : undefined;
			new Dipendente().fill(obj.dipendente);
		};

		Dipendenza.prototype.fillAll = function(objects) {
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
				Dipendenza.prototype.fill(objects.list[obj]);
			}
		};

		return Dipendenza;
	}
]);
