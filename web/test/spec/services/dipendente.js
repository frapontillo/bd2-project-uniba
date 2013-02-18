'use strict';

describe('Service: dipendente', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var dipendente;
  beforeEach(inject(function(_dipendente_) {
    dipendente = _dipendente_;
  }));

  it('should do something', function () {
    expect(!!dipendente).toBe(true);
  });

});
