Module: tracing-core
Synopsis: A timeline annotation is attached to a span to note an event.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define class <timeline-annotation> (<object>)
  constant slot description :: <string>,
    required-init-keyword: description:;
  constant slot timestamp :: <timestamp>,
    required-init-keyword: timestamp:;
end class <timeline-annotation>;
