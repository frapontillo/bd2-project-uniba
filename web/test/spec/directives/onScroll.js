'use strict';

describe('Directive: onScroll', function() {
  beforeEach(module('webApp'));

  var element;

  it('should make hidden element visible', inject(function($rootScope, $compile) {
    element = angular.element('<on-scroll></on-scroll>');
    element = $compile(element)($rootScope);
    expect(element.text()).toBe('this is the onScroll directive');
  }));
});
