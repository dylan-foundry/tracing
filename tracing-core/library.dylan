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

  export <span>,
         span-id,
         span-trace-id,
         span-parent-id,
         span-description,
         annotate-span,
         stop-span,
         span-accumulated-time,
         span-stopped?;

  export <timeline-annotation>,
         annotation-description,
         annotation-timestamp;

  export $always-sampler,
         $never-sampler,
         $if-tracing-sampler;

  export enable-tracing,
         disable-tracing;
end module tracing-core;
