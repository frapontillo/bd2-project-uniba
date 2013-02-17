'use strict';

webApp.directive('date', function(dateFilter) {
	return {
		require: 'ngModel',
		link: function(scope, elm, attrs, ctrl) {
			var dateObj, dateFormat, dateParse;

			var validate = function(date, dateRep) {
				return (dateRep == dateFilter(date, dateFormat));
			};

			// Watch for the attribute changing
			scope.$watch(attrs, function() {
				dateObj = scope.$eval(attrs['date']);
				dateFormat = dateObj.filter;
				dateParse = dateObj.parse;
			});

			ctrl.$parsers.unshift(function(viewValue) {
				var mDate = moment(viewValue, dateParse);
				if (validate(mDate._d, viewValue)) {
					// it is valid
					ctrl.$setValidity('date', true);
					return mDate._d;
				} else {
					// it is invalid, return undefined (no model update)
					ctrl.$setValidity('date', false);
					return "";
				}
			});

			ctrl.$formatters.unshift(function(modelValue) {
				return dateFilter(modelValue, dateFormat);
			});
		}
	};
});
