'use strict';

describe('Controller: DipendenteCtrl', function() {

  // load the controller's module
  beforeEach(module('webApp'));

  var DipendenteCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function($controller) {
    scope = {};
    DipendenteCtrl = $controller('DipendenteCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function() {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
