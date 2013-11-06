module: tracing-core
synopsis: span functionality, basis of a trace tree.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define class <span> (<object>)
  constant slot parent-id :: false-or(<unique-id>) = #f,
    init-keyword: parent-id:;
  constant slot description :: <string>,
    required-init-keyword: description:;
  slot timeline-annotations :: limited(<vector>, of: <timeline-annotation>);
end class <span>;

define method annotate-span (span :: <span>, description :: <string>)
  let annotation = make(<timeline-annotation>,
                        description: description,
                        timestamp: timestamp-now());
  span.timeline-annotations := add(span.timeline-annotations, annotation);
end;
