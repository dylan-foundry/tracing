module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library tracing-core-test-suite
  use common-dylan;
  use io;
  use tracing-core;
  use testworks;

  export tracing-core-test-suite;
end library;

define module tracing-core-test-suite
  use common-dylan, exclude: { format-to-string };
  use format;
  use tracing-core;
  use streams, import: { <buffer> };
  use testworks;

  export tracing-core-test-suite;
end module;
