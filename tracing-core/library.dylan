module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library tracing-core
  use common-dylan;
  use collections;

  export tracing-core;
end library tracing-core;

define module tracing-core
  use dylan;
  use common-dylan;
  use finalization;
  use plists;
  use simple-random;

  export trace-push,
         trace-add-data,
         trace-annotate,
         trace-pop,
         trace-set-host,
         trace-current-spans,
         \with-tracing;

  export <span>,
         span-id,
         span-trace-id,
         span-parent-id,
         span-description,
         span-annotations,
         span-annotate,
         span-data,
         span-add-data,
         span-host,
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
         disable-tracing,
         tracing-enabled?;

  export <span-writer>,
         span-writer-add-span,
         register-span-writer,
         unregister-span-writer,
         registered-span-writers,
         store-span,
         <memory-span-writer>,
         memory-span-storage;

  export get-unique-id;
end module tracing-core;
