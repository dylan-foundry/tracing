Module: tracing-core
Synopsis: timestamp management
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define class <duration> (<object>)
  constant slot duration-seconds :: <integer>,
    required-init-keyword: seconds:;
  constant slot duration-microseconds :: <integer>,
    required-init-keyword: microseconds:;
end class <duration>;
