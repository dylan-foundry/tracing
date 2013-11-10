Module: tracing-core
Synopsis: Write spans to storage.
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define class <span-writer> (<object>)
end class <span-writer>;

define generic span-writer-add-span (span :: <span>, span-writer :: <span-writer>) => ();

define constant <span-writer-vector> = limited(<vector>, of: <span-writer>);

define variable *span-writers* :: <span-writer-vector> = make(<span-writer-vector>);

define function register-span-writer (span-writer :: <span-writer>) => ()
  *span-writers* := add!(*span-writers*, span-writer);
end function;

define function unregister-span-writer (span-writer :: <span-writer>) => ()
  *span-writers* := remove!(*span-writers*, span-writer);
end function;

define function registered-span-writers () => (span-writers :: <span-writer-vector>)
  *span-writers*
end function;

define function store-span (span :: <span>) => ()
  for (span-writer :: <span-writer> in *span-writers*)
    span-writer-add-span(span, span-writer);
  end for;
end function;

define class <memory-span-writer> (<span-writer>)
  slot memory-span-storage :: <stretchy-vector> = make(<stretchy-vector>);
end class <memory-span-writer>;

define method span-writer-add-span (span :: <span>, span-writer :: <memory-span-writer>) => ()
  span-writer.memory-span-storage := add!(span-writer.memory-span-storage, span);
end method;