Module: tracing-core
Synopsis: Samplers let you control how many traces are actually recorded.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define function always-sample () => (record-sample? :: <boolean>)
  #t
end function always-sample;

define function never-sample () => (record-sample? :: <boolean>)
  #f
end function never-sample;

define variable *tracing-enabled* = #t;

define function if-tracing-sample () => (record-sample? :: <boolean>)
  *tracing-enabled*
end function if-tracing-sample;

define function enable-tracing ()
  *tracing-enabled* := #t;
end function;

define function disable-tracing ()
  *tracing-enabled* := #f;
end function;
