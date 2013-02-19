'use strict';

describe('Controller: AnalisiCtrl', function() {

  // load the controller's module
  beforeEach(module('webApp'));

  var AnalisiCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function($controller) {
    scope = {};
    AnalisiCtrl = $controller('AnalisiCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function() {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
