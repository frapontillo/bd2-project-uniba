'use strict';

webApp.factory('UserSession', ['$resource', 'Config',
	function($resource, Config) {
		var UserSessionResource = $resource(Config.baseAPI() + 'usersession', {},
			{
				get: {method: 'GET', params: {authcode:''}},
				post: {method: 'POST', params: {username:'', password:''}},
				delete: {method: 'DELETE', params:{authcode:''}}
			}
		);

		UserSessionResource.login = function(username, password, success, fail) {
			return new UserSessionResource().$post({username:username, password:password}, function (result) {
				fill(result);
				success(result);
			}, fail)
		};

		UserSessionResource.logout = function(authcode, success, fail) {
			return UserSessionResource.delete({authcode:authcode}, function (result) {
				success(result);
			}, fail)
		};

		UserSessionResource.prototype.fill = function() {
			fill(this);
		};

		UserSessionResource.prototype.fillAll = function(objects) {
			if (!objects) return;
			for (var obj in objects) {
				fill(objects[obj]);
			}
		};

		var fill = function(obj) {
		};

		return UserSessionResource;
	}
]);
