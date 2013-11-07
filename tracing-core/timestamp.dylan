Module: tracing-core
Synopsis: timestamp management
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

// TODO: Make this a more precise type.
define constant <timestamp> = <integer>;
define constant <duration> = <integer>;

// TODO: Implement!
define function timestamp-now () => (now :: <timestamp>)
  0
end function timestamp-now;
