'use strict';

describe('Service: tipoAttivita', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var tipoAttivita;
  beforeEach(inject(function(_tipoAttivita_) {
    tipoAttivita = _tipoAttivita_;
  }));

  it('should do something', function () {
    expect(!!tipoAttivita).toBe(true);
  });

});
