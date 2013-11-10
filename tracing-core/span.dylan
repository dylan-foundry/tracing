module: tracing-core
synopsis: span functionality, basis of a trace tree.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define constant <span-annotation-vector> =
  limited(<vector>, of: <span-annotation>);

define class <span> (<object>)
  constant slot span-id :: <unique-id> = get-unique-id();
  constant slot span-trace-id :: <unique-id>,
    required-init-keyword: trace-id:;
  constant slot span-parent-id :: false-or(<unique-id>) = #f,
    init-keyword: parent-id:;
  constant slot span-description :: <string>,
    required-init-keyword: description:;
  slot span-annotations :: false-or(<span-annotation-vector>) = #f;
  slot span-data :: false-or(<vector>) = #f;
  constant slot span-start-time :: <timestamp> = timestamp-now();
  slot span-stop-time :: <timestamp> = 0;
end class <span>;

define method initialize (span :: <span>, #key)
  finalize-when-unreachable(span);
end method initialize;

define method finalize (span :: <span>) => ()
  span-annotate(span, "Finalizing due to GC.");
  span-stop(span);
end method finalize;

define method span-annotate (span :: <span>, description :: <string>)
  let annotation = make(<span-annotation>,
                        description: description,
                        timestamp: timestamp-now());
  if (~span.span-annotations)
    span.span-annotations := make(<span-annotation-vector>);
  end if;
  span.span-annotations := add(span.span-annotations, annotation);
end method span-annotate;

define method span-add-data (span :: <span>, key :: <string>, data :: <string>) => ();
  if (~span.span-data)
    span.span-data := make(<stretchy-vector>);
  end if;
  put-property!(span.span-data, key, data);
end method span-add-data;


define method span-stop (span :: <span>)
  span.span-stop-time := timestamp-now();
  store-span(span);
end method span-stop;

define method span-stopped? (span :: <span>) => (well? :: <boolean>);
  span.span-stop-time ~= 0
end method span-stopped?;


define method span-accumulated-time (span :: <span>) => (time? :: false-or(<duration>))
  if (span.span-stopped?)
    span.span-stop-time - span.span-start-time
  end if
end method span-accumulated-time;
