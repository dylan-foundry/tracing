Module: tracing-core
Synopsis: Samplers let you control how many traces are actually recorded.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define constant $always-sampler = always(#t);

define constant $never-sampler = always(#f);

define variable *tracing-enabled* = #t;

define constant $if-tracing-sampler = method () => (well? :: <boolean>) *tracing-enabled* end;

define function enable-tracing ()
  *tracing-enabled* := #t;
end function;

define function disable-tracing ()
  *tracing-enabled* := #f;
end function;
