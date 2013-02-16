'use strict';

webApp.factory('Struttura', function($resource, Config, AuthHandler) {
	var StrutturaResourceTempl = $resource(Config.baseAPI() + 'struttura/:id', {},
		{
			_query: {method: 'GET', params: {authcode: '', codice: '', page: '1'}},
			_get: {method: 'GET', params: {authcode:'', id:''}},
			_post: {method: 'POST', params: {authcode:''}},
			_put: {method: 'PUT', params: {authcode:''}},
			_delete: {method: 'DELETE', params:{authcode:''}}
		}
	);

	var StrutturaResource = function() {
		var self = this;

		self.isCancelled = false;
		self.cancel = function() {this.isCancelled = true;}

		self.query = function(codice, page, success, fail) {
			new StrutturaResourceTempl().$_query({codice:codice, page:page||'1', authcode:AuthHandler.getAuthcode()},
				function (result) {
					if (!self.isCancelled) {
						fillAll(result);
						success(result);
					}
				}, fail);
			return self;
		};

		self.get = function(id, success, fail) {
			new StrutturaResourceTempl().$_get({id:id, authcode:AuthHandler.getAuthcode()},
				function (result) {
					fill(result);
					success(result);
				}, fail);
			return self;
		};

		self.post = function(struttura, success, fail) {
			new StrutturaResourceTempl().$_post(struttura, {authcode:AuthHandler.getAuthcode},
				function (result) {
					fill(result);
					success(result);
				}, fail);
			return self;
		};

		self.put = function(id, struttura, success, fail) {
			StrutturaResourceTempl.$put({id:id, authcode:AuthHandler.getAuthcode}, struttura,
				function (result) {
					fill(result);
					success(result);
				}, fail);
			return self;
		};

		self.fill = function() {
			fill(this);
		};

		self.fillAll = function(objects) {
			fillAll(objects);
		};
	};

	var fill = function(obj) {
		obj.cod = obj.tipo.codice + '-' + obj.id;
	};

	var fillAll = function(objects) {
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
			fill(objects.list[obj]);
		}
	};

	return StrutturaResource;
});
