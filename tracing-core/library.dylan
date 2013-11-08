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
         span-annotations,
         span-annotate,
         span-stop,
         span-accumulated-time,
         span-stopped?;

  export <span-annotation>,
         annotation-description,
         annotation-timestamp;

  export $always-sample,
         $never-sample,
         $if-tracing-sample;

  export enable-tracing,
         disable-tracing;

  export <span-writer>,
         span-writer-add-span,
         add-span-writer,
         store-span;
end module tracing-core;
