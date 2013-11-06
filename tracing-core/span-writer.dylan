Module: tracing-core
Synopsis: Write spans to storage.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define class <span-writer> (<object>)
end class <span-writer>;

define generic write-span (span :: <span>, span-writer :: <span-writer>) => ();

define constant <span-writer-vector> = limited(<vector>, of: <span-writer>);

define variable *span-writers* :: <span-writer-vector> = make(<span-writer-vector>);

define function add-span-writer (span-writer :: <span-writer>) => ()
  *span-writers* := add!(*span-writers*, span-writer);
end function;

define function store-span (span :: <span>) => ()
  for (span-writer :: <span-writer> in *span-writers*)
    write-span(span, span-writer);
  end for;
end function;
