tracing
=======

This is a tracing library based on the `Dapper`_ work by Google.

The overall architecture is pretty simple. A trace is a tree of
spans, each span representing some part of the overall computation.

In the future, we may provide a span writer for connecting
with Twitter's `Zipkin`_.

Documentation can be found at http://opendylan.org/documentation/tracing/

.. _Dapper: http://research.google.com/pubs/pub36356.html
.. _Zipkin: https://github.com/twitter/zipkin
