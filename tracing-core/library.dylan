module: dylan-user
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define library tracing-core
  use common-dylan;
  use collections;
  use system;

  export tracing-core;
end library tracing-core;

define module tracing-core
  use dylan;
  use common-dylan;
  use date, import: { current-timestamp };
  use finalization;
  use plists;
  use simple-random;
  use simple-timers;

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
         span-start-time,
         span-duration,
         span-annotations,
         span-annotate,
         span-data,
         span-add-data,
         span-host,
         span-stop,
         span-stopped?;

  export <span-annotation>,
         annotation-description,
         annotation-timestamp;

  export always-sample,
         never-sample,
         if-tracing-sample;

  export enable-tracing,
         disable-tracing;

  export <span-writer>,
         span-writer-add-span,
         register-span-writer,
         unregister-span-writer,
         registered-span-writers,
         store-span,
         <memory-span-writer>,
         memory-span-storage;

  export <duration>,
         duration-seconds,
         duration-microseconds;

  export <timestamp>,
         timestamp-days,
         timestamp-seconds,
         timestamp-microseconds;

  export get-unique-id;

  // For tests
  export add-duration-to-timestamp;
end module tracing-core;
