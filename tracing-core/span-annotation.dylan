Module: tracing-core
Synopsis: An annotation is attached to a span to note an event.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define class <span-annotation> (<object>)
  constant slot annotation-description :: <string>,
    required-init-keyword: description:;
  constant slot annotation-timestamp :: <timestamp>,
    required-init-keyword: timestamp:;
end class <span-annotation>;
