'use strict';

describe('Directive: date', function() {
  beforeEach(module('webApp'));

  var element;

  it('should make hidden element visible', inject(function($rootScope, $compile) {
    element = angular.element('<date></date>');
    element = $compile(element)($rootScope);
    expect(element.text()).toBe('this is the date directive');
  }));
});
