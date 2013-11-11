Module: tracing-core
Synopsis: High level interface to tracing
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define thread variable *current-spans* :: <list> = #();

define method trace-push
    (description,
     #key sampler = $always-sample)
 => (span? :: false-or(<span>))
  if (sampler())
    let (trace-id, parent-id)
      = if (~empty?(*current-spans*))
          let current-span = *current-spans*.head;
          values(current-span.span-trace-id,
                 current-span.span-id)
        else
          values(get-unique-id(), #f)
        end if;
    let span = make(<span>,
                    description: description,
                    trace-id: trace-id,
                    parent-id: parent-id);
    *current-spans* := add(*current-spans*, span);
    span
  else
    #f
  end if;
end method trace-push;

define function trace-add-data (key :: <string>, value :: <string>) => ()
  if (~empty?(*current-spans*))
    span-add-data(*current-spans*.head, key, value);
  end if;
end function trace-add-data;

define function trace-annotate (description :: <string>) => ()
  if (~empty?(*current-spans*))
    span-annotate(*current-spans*.head, description);
  end if;
end function trace-annotate;

define function trace-pop (span? :: false-or(<span>)) => ()
  if (span?)
    if (~empty?(*current-spans*))
      // TODO: Should we check that the head span matches the span passed in?
      span-stop(*current-spans*.head);
      *current-spans* := *current-spans*.tail;
    end if;
  end if;
end function trace-pop;

define function trace-current-spans () => (spans :: <list>);
  *current-spans*
end function trace-current-spans;

define macro with-tracing
  { with-tracing (?description:expression) ?:body end }
 =>
  {
    let span = trace-push(?description);
    block ()
      ?body
    cleanup
      trace-pop(span);
    end block;
  }
end macro with-tracing;
