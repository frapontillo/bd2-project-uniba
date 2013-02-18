'use strict';

describe('Service: dipendenza', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var dipendenza;
  beforeEach(inject(function(_dipendenza_) {
    dipendenza = _dipendenza_;
  }));

  it('should do something', function () {
    expect(!!dipendenza).toBe(true);
  });

});
