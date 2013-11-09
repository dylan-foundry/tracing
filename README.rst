tracing
=======

This is a tracing library based on the `Dapper`_ work by Google.

The overall architecture is pretty simple. A trace is a tree of
spans, each span representing some part of the overall computation.
A span has a duration along with annotations providing extra data.

Tracing Instrumentation
-----------------------

This part of the API isn't written yet.

Sampling
--------

Samplers allow for collecting a subset of the data, making the
usage of this tracing framework in a heavily loaded production
scenario more realistic.

Samplers are simply a function that returns a boolean value
indicating whether or not an actual trace should be generated
and recorded.

.. note:: In the future, the sampler will take arguments
   to let it make contextual decisions about sampling.

Storage
-------

Spans are written to storage, represented by ``<span-writer>``.
To add a new storage, subclass ``<span-writer>`` and implement
the ``span-writer-add-span`` method. Then, call ``register-span-writer``
with an instance of your span writer and all subsequent spans
completed will be written to it.

In the future, we will provide a span writer for connecting
with Twitter's `Zipkin`_.

.. _Dapper: http://research.google.com/pubs/pub36356.html
.. _Zipkin: https://github.com/twitter/zipkin
