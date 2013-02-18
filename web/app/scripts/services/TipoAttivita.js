'use strict';

webApp.factory('TipoAttivita', function($resource, Config, AuthHandler) {
	var TipoAttivita = $resource(Config.baseAPI() + 'tipoattivita/:id', {},
		{
			_query: {method: 'GET', params: {authcode: '', skip: '', top: ''}},
			_get: {method: 'GET', params: {authcode:'', id:''}}
		}
	);

	TipoAttivita.prototype.query = function(skip, top, success, fail) {
		return TipoAttivita._query({skip:skip||'', top:top||'', authcode:AuthHandler.getAuthcode()},
			function (result) {
				result = TipoAttivita.prototype.fillAll(result);
				if (success && angular.isFunction(success)) success(result);
			}, fail);
	};

	TipoAttivita.prototype.get = function(id, success, fail) {
		return TipoAttivita._get({id:id, authcode:AuthHandler.getAuthcode()},
			function (result) {
				result = TipoAttivita.prototype.fill(result);
				if (success && angular.isFunction(success)) success(result);
			}, fail);
	};

	TipoAttivita.prototype.fill = function(obj) {
		return obj;
	};

	TipoAttivita.prototype.fillAll = function(objects) {
		// Se non è un array
		if (!angular.isArray(objects)) {
			// Se la lista interna non è un array la trasformo in un array
			if (objects.tipoAttivita && angular.isArray(objects.tipoAttivita)) {
				objects = objects.tipoAttivita;
			}
		}
		if (!objects) return;
		for (var obj in objects) {
			obj = TipoAttivita.prototype.fill(objects[obj]);
		}
		return objects;
	};

	return TipoAttivita;
});
