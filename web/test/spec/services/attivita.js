'use strict';

describe('Service: attivita', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var attivita;
  beforeEach(inject(function(_attivita_) {
    attivita = _attivita_;
  }));

  it('should do something', function () {
    expect(!!attivita).toBe(true);
  });

});
