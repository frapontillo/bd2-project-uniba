'use strict';

webApp.factory('TipoStruttura', ['$resource', 'Config', 'AuthHandler',
	function($resource, Config, AuthHandler) {
		var TipoStruttura = $resource(Config.baseAPI() + 'tipostruttura/:id', {},
			{
				_query: {method: 'GET', params: {authcode: '', skip: '', top: ''}},
				_get: {method: 'GET', params: {authcode:'', id:''}}
			}
		);

		TipoStruttura.prototype.query = function(skip, top, success, fail) {
			return TipoStruttura._query({skip:skip||'', top:top||'', authcode:AuthHandler.getAuthcode()},
				function (result) {
					result = TipoStruttura.prototype.fillAll(result);
					if (success && angular.isFunction(success)) success(result);
				}, fail);
		};

		TipoStruttura.prototype.get = function(id, success, fail) {
			return TipoStruttura._get({id:id, authcode:AuthHandler.getAuthcode()},
				function (result) {
					result = TipoStruttura.prototype.fill(result);
					if (success && angular.isFunction(success)) success(result);
				}, fail);
		};

		TipoStruttura.prototype.fill = function(obj) {
			return obj;
		};

		TipoStruttura.prototype.fillAll = function(objects) {
			// Se non è un array
			if (!angular.isArray(objects)) {
				// Se la lista interna non è un array la trasformo in un array
				if (objects.tipoStruttura && angular.isArray(objects.tipoStruttura)) {
					objects = objects.tipoStruttura;
				}
			}
			if (!objects) return;
			for (var obj in objects) {
				obj = TipoStruttura.prototype.fill(objects[obj]);
			}
			return objects;
		};

		return TipoStruttura;
	}
]);
