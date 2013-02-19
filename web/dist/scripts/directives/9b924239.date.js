'use strict';

webApp.directive('date', ['dateFilter',
	function(dateFilter) {
		return {
			require: 'ngModel',
			link: function(scope, elm, attrs, ctrl) {
				var dateObj, dateFormat, dateParse, required;

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
					if (mDate && validate(mDate._d, viewValue)) {
						// Valido
						ctrl.$setValidity('date', true);
						return mDate._d;
					} else {
						// Non valido
						ctrl.$setValidity('date', true);
						return "";
					}
				});

				ctrl.$formatters.unshift(function(modelValue) {
					return dateFilter(modelValue, dateFormat);
				});
			}
		};
	}
]);
