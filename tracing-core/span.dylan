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
  slot span-start-time :: <timestamp>;
  constant slot span-timer :: <profiling-timer> = make(<profiling-timer>);
  slot span-duration :: false-or(<duration>) = #f;
  slot span-host :: <string> = "";
end class <span>;

define method initialize (span :: <span>, #key)
  span-host(span) := *trace-host*;
  finalize-when-unreachable(span);
  timer-start(span-timer(span));
  let (s, us) = timer-accumulated-time(*trace-timer-since-start*);
  span-start-time(span) := add-duration-to-timestamp(*trace-application-start-time*, s, us);
end method initialize;

define method finalize (span :: <span>) => ()
  if (~span-stopped?(span))
    span-annotate(span, "Finalizing due to GC.");
    span-stop(span);
  end if;
end method finalize;

define method span-annotate (span :: <span>, description :: <string>)
  let (s, us) = span.span-timer.timer-accumulated-time;
  let duration = make(<duration>, seconds: s, microseconds: us);
  let annotation = make(<span-annotation>,
                        description: description,
                        timestamp: duration);
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
  if (~span-stopped?(span))
    let (seconds, microseconds) = timer-stop(span.span-timer);
    span.span-duration := make(<duration>,
                               seconds: seconds,
                               microseconds: microseconds);
    store-span(span);
  end if;
end method span-stop;

define method span-stopped? (span :: <span>) => (stopped? :: <boolean>);
  ~span.span-timer.timer-running?
end method span-stopped?;
