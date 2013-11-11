Module: tracing-core
Synopsis: High level interface to tracing
Author: Bruce Mitchener, Jr.
Copyright: See LICENSE file in this distribution.

define thread variable *current-spans* :: <deque> = make(<deque>);

define method trace-push
    (#key sampler = $always-sample)
 => (span? :: false-or(<span>))
  if (sampler())
    let span = make(<span>);
    push(*current-spans*, span)
  else
    #f
  end if;
end method trace-push;

define function trace-add-data (key :: <string>, value :: <string>) => ()
  if (~empty?(*current-spans*))
    span-add-data(*current-spans*.first, key, value);
  end if;
end function trace-add-data;

define function trace-annotate (description :: <string>) => ()
  if (~empty?(*current-spans*))
    span-annotate(*current-spans*.first, description);
  end if;
end function trace-annotate;

define function trace-pop (span? :: false-or(<span>)) => ()
  if (span?)
    if (~empty?(*current-spans*))
      // TODO: Should we check that the first span matches the span passed in?
      span-stop(*current-spans*.first);
      pop(*current-spans*);
    end if;
  end if;
end function trace-pop;
