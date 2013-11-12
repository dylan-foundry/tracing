Module: tracing-core
Synopsis: Samplers let you control how many traces are actually recorded.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define constant $always-sample = always(#t);

define constant $never-sample = always(#f);

define variable *tracing-enabled* = #t;

define constant $if-tracing-sample = method () => (record-sample? :: <boolean>) *tracing-enabled* end;

define function enable-tracing ()
  *tracing-enabled* := #t;
end function;

define function disable-tracing ()
  *tracing-enabled* := #f;
end function;

define function tracing-enabled? () => (enabled? :: <boolean>)
  *tracing-enabled*
end function;
