Module: tracing-core
Synopsis:
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

// TODO: Make this more precise
define constant <unique-id> = <integer>;
define constant $random = make(<random>);

define function get-unique-id () => (id :: <unique-id>)
  random($maximum-integer, random: $random)
end function;
