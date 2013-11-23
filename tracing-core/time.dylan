Module: tracing-core
Synopsis: time-related utilities
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define class <duration> (<object>)
  constant slot duration-seconds :: <integer>,
    required-init-keyword: seconds:;
  constant slot duration-microseconds :: <integer>,
    required-init-keyword: microseconds:;
end class <duration>;

define class <timestamp> (<object>)
  constant slot timestamp-seconds :: <integer>,
    required-init-keyword: seconds:;
  constant slot timestamp-microseconds :: <integer>,
    required-init-keyword: microseconds:;
end class <timestamp>;
