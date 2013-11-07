module: tracing-core
synopsis: span functionality, basis of a trace tree.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define constant <timeline-annotation-vector> =
  limited(<vector>, of: <timeline-annotation>);

define class <span> (<object>)
  constant slot span-id :: <unique-id> = get-unique-id();
  constant slot span-trace-id :: <unique-id>,
    required-init-keyword: trace-id:;
  constant slot span-parent-id :: false-or(<unique-id>) = #f,
    init-keyword: parent-id:;
  constant slot span-description :: <string>,
    required-init-keyword: description:;
  slot timeline-annotations :: false-or(<timeline-annotation-vector>) = #f;
  constant slot span-start-time :: <timestamp> = timestamp-now();
  slot span-stop-time :: <timestamp> = 0;
end class <span>;

define method annotate-span (span :: <span>, description :: <string>)
  let annotation = make(<timeline-annotation>,
                        description: description,
                        timestamp: timestamp-now());
  if (~span.timeline-annotations)
    span.timeline-annotations := make(<timeline-annotation-vector>);
  end if;
  span.timeline-annotations := add(span.timeline-annotations, annotation);
end;

define method stop-span (span :: <span>)
  span.span-stop-time := timestamp-now();
  store-span(span);
end method stop-span;

define method span-stopped? (span :: <span>) => (well? :: <boolean>);
  span.span-stop-time ~= 0
end method span-stopped?;


define method span-accumulated-time (span :: <span>)
  if (span.span-stopped?)
    span.span-stop-time - span.span-start-time
  end if
end method span-accumulated-time;
