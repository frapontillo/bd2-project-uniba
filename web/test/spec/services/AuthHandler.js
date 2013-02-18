'use strict';

describe('Service: AuthHandler', function () {

  // load the service's module
  beforeEach(module('webApp'));

  // instantiate service
  var AuthHandler;
  beforeEach(inject(function(_AuthHandler_) {
    AuthHandler = _AuthHandler_;
  }));

  it('should do something', function () {
    expect(!!AuthHandler).toBe(true);
  });

});
