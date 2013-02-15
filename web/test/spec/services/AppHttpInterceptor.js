'use strict';

describe('Service: AppHttpInterceptor', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var AppHttpInterceptor;
  beforeEach(inject(function(_AppHttpInterceptor_) {
    AppHttpInterceptor = _AppHttpInterceptor_;
  }));

  it('should do something', function () {
    expect(!!AppHttpInterceptor).toBe(true);
  });

});
