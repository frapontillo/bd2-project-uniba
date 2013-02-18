'use strict';

describe('Service: struttura', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var struttura;
  beforeEach(inject(function(_struttura_) {
    struttura = _struttura_;
  }));

  it('should do something', function () {
    expect(!!struttura).toBe(true);
  });

});
