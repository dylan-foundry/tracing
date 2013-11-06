module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library tracing-core
  use common-dylan;

  export tracing-core;
end library tracing-core;

define module tracing-core
  use dylan;
  use common-dylan;

  export <span>, annotate-span;

  export $always-sampler,
         $never-sampler,
         $if-tracing-sampler;

  export enable-tracing,
         disable-tracing;
end module tracing-core;
