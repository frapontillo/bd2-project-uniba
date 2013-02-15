'use strict';

describe('Controller: StrutturaCtrl', function() {

  // load the controller's module
  beforeEach(module('webApp'));

  var StrutturaCtrl,
    scope;

  // Initialize the controller and a mock scope
  beforeEach(inject(function($controller) {
    scope = {};
    StrutturaCtrl = $controller('StrutturaCtrl', {
      $scope: scope
    });
  }));

  it('should attach a list of awesomeThings to the scope', function() {
    expect(scope.awesomeThings.length).toBe(3);
  });
});
