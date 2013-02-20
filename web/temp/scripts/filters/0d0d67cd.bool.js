/**
 * Created with JetBrains WebStorm.
 * User: francescopontillo
 * Date: 17/02/13
 * Time: 11:31
 */

webApp.filter('bool', function() {
	return function(value, replace) {
		var replaceTrue = replace[0];
		var replaceFalse = replace[1];
		return (value ? replaceTrue : replaceFalse);
	};
});
