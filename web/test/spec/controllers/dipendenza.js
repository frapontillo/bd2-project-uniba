'use strict';

describe('Controller: DipendenzaCtrl', function() {

  // load the controller's module
  beforeEach(module('webApp'));

  var DipendenzaCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function($controller) {
    scope = {};
    DipendenzaCtrl = $controller('DipendenzaCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function() {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
