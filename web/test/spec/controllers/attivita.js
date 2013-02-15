'use strict';

describe('Controller: AttivitaCtrl', function() {

  // load the controller's module
  beforeEach(module('webApp'));

  var AttivitaCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function($controller) {
    scope = {};
    AttivitaCtrl = $controller('AttivitaCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function() {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
