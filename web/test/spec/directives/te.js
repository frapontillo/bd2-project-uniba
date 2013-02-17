'use strict';

describe('Directive: te', function() {
  beforeEach(module('webApp'));

  var element;

  it('should make hidden element visible', inject(function($rootScope, $compile) {
    element = angular.element('<te></te>');
    element = $compile(element)($rootScope);
    expect(element.text()).toBe('this is the te directive');
  }));
});
