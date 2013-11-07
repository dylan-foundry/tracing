module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library tracing-test-suite
  use testworks;
  use tracing-core-test-suite;

  export tracing-test-suite;
end library;

define module tracing-test-suite
  use testworks;

  use tracing-core-test-suite;

  export tracing-test-suite;
end module;
