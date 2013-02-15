'use strict';

describe('Service: tipoStruttura', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var tipoStruttura;
  beforeEach(inject(function(_tipoStruttura_) {
    tipoStruttura = _tipoStruttura_;
  }));

  it('should do something', function () {
    expect(!!tipoStruttura).toBe(true);
  });

});
