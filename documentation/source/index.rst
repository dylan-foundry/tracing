*******
Tracing
*******

.. current-library:: tracing

This is a tracing library based on the `Dapper`_ work by Google.

.. _Dapper: http://research.google.com/pubs/pub36356.html

The TRACING-CORE module
=======================

.. current-module:: tracing-core

The overall architecture is pretty simple. A trace is a tree of
:class:`spans <<span>>`, each span representing some part of an overall
computation, with a root span at the top of the tree that encompasses
an entire computation.

Spans are written to storage by :gf:`stopping <span-stop>` them.

.. contents::
   :local:

Spans
-----

.. class:: <span>

   :superclasses: <object>

   :keyword description:
   :keyword parent-id:
   :keyword trace-id:

.. generic-function:: span-accumulated-time

   :signature: span-accumulated-time (span) => (time?)

   :parameter span: An instance of :class:`<span>`.
   :value time?: An instance of ``false-or(<duration>)``.

   :description:

     If the span has not yet been stopped, this returns ``#f``. Once
     the span has been stopped, the duration that the span was running
     will be returned.

.. generic-function:: span-add-data

   :signature: span-add-data (span key data) => ()

   :parameter span: An instance of :class:`<span>`.
   :parameter key: An instance of :drm:`<string>`.
   :parameter data: An instance of :drm:`<string>`.

   :description:

      Key / value pairs may be stored on a span to provide better
      context. This might include the query being executed, address
      or host information or whatever is relevant to the application
      being traced.

   See also:

   * :gf:`span-data`

.. generic-function:: span-annotate

   :signature: span-annotate (span description) => ()

   :parameter span: An instance of :class:`<span>`.
   :parameter description: An instance of :drm:`<string>`.

   :description:

      Annotations are to record an occurrence of an event
      during a span. They have a specific timestamp associated
      with them that is automatically set to the time when
      the annotation is created.

   See also:

   * :gf:`span-annotations`
   * :class:`<span-annotation>`
   * :gf:`annotation-description`
   * :gf:`annotation-timestamp`

.. generic-function:: span-annotations

   Returns the collection of :class:`<span-annotation>` associated with
   this span.

   :signature: span-annotations (span) => (annotations)

   :parameter span: An instance of :class:`<span>`.
   :value annotations: An instance of :drm:`<vector>`.

   See also:

   * :gf:`span-annotate`
   * :class:`<span-annotation>`
   * :gf:`annotation-description`
   * :gf:`annotation-timestamp`

.. generic-function:: span-data

   Returns the property list of data associated with this span.

   :signature: span-data (span) => (data)

   :parameter span: An instance of :class:`<span>`.
   :value data: An instance of :drm:`<vector>`.

   See also:

   * :gf:`span-add-data`

.. generic-function:: span-description

   Returns the description of the span.

   :signature: span-description (span) => (description)

   :parameter span: An instance of :class:`<span>`.
   :value description: An instance of :drm:`<string>`.

.. generic-function:: span-id

   Returns the unique ID associated with this span.

   :signature: span-id (span) => (id)

   :parameter span: An instance of :class:`<span>`.
   :value id: An instance of ``<object>``.

.. generic-function:: span-parent-id

   :signature: span-parent-id (span) => (id)

   :parameter span: An instance of :class:`<span>`.
   :value id: An instance of ``<object>``.

.. generic-function:: span-stop

   Stops a span and sends it to the current registered
   :class:`<span-writer>` instances.

   :signature: span-stop (span) => ()

   :parameter span: An instance of :class:`<span>`.

   See also:

   * :gf:`span-stopped?`

.. generic-function:: span-stopped?

   Has the span been stopped yet?

   :signature: span-stopped? (span) => (well?)

   :parameter span: An instance of :class:`<span>`.
   :value #rest results: An instance of :drm:`<boolean>`.

   See also:

   * :gf:`span-stop`

.. generic-function:: span-trace-id

   :signature: span-trace-id (span) => (id)

   :parameter span: An instance of :class:`<span>`.
   :value id: An instance of ``<object>``.

Annotations
-----------

Annotations let you attach events that happened at a point in time
(noted by a timestamp) to a span.

.. class:: <span-annotation>

   :superclasses: <object>

   :keyword description:
   :keyword timestamp:

.. generic-function:: annotation-description

   Return the description of an annotation.

   :signature: annotation-description (annotation) => (description)

   :parameter annotation: An instance of :class:`<span-annotation>`.
   :value description: An instance of :drm:`<string>`.

.. generic-function:: annotation-timestamp

   Return the timestamp at which the annotation was created and attached.

   :signature: annotation-timestamp (annotation) => (timestamp)

   :parameter annotation: An instance of :class:`<span-annotation>`.
   :value timestamp: An instance of :class:`<timestamp>`.

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

.. function:: $always-sample

   Alaways returns true, so that the trace is sampled.

   :signature: $always-sample () => (well?)

   :value well?: An instance of :drm:`<boolean>`.

.. function:: $if-tracing-sample

   Returns true if tracing is enabled, otherwise ``#f``.

   :signature: $if-tracing-sample () => (well?)

   :value well?: An instance of :drm:`<boolean>`.

   See also:

   * :func:`disable-tracing`
   * :func:`enable-tracing`
   * :func:`tracing-enabled?`

.. function:: $never-sample

   Always returns false, so that the trace isn't sampled.

   :signature: $never-sample () => (well?)

   :value well?: An instance of :drm:`<boolean>`.

.. function:: disable-tracing

   :signature: disable-tracing () => ()

   See also:

   * :func:`enable-tracing`
   * :func:`tracing-enabled?`

.. function:: enable-tracing

   :signature: enable-tracing () => ()

   See also:

   * :func:`disable-tracing`
   * :func:`tracing-enabled?`

.. function:: tracing-enabled?

   :signature: tracing-enabled? () => (well?)

   :value well?: An instance of :drm:`<boolean>`.

   See also:

   * :func:`disable-tracing`
   * :func:`enable-tracing`

Writers
-------

.. class:: <span-writer>

   :superclasses: <object>

   See also:

   * :func:`register-span-writer`
   * :func:`registered-span-writers`
   * :func:`unregister-span-writer`

.. function:: register-span-writer

   :signature: register-span-writer (span-writer) => ()

   :parameter span-writer: An instance of :class:`<span-writer>`.

   See also:

   * :class:`<span-writer>`
   * :func:`registered-span-writers`
   * :func:`unregister-span-writer`

.. function:: registered-span-writers

   :signature: registered-span-writers () => (span-writers)

   :value span-writers: An instance of ``<span-writer-vector>``.

   See also:

   * :class:`<span-writer>`
   * :func:`register-span-writer`
   * :func:`unregister-span-writer`

.. function:: store-span

   :signature: store-span (span) => ()

   :parameter span: An instance of :class:`<span>`.

   See also:

   * :func:`registered-span-writers`

.. function:: unregister-span-writer

   :signature: unregister-span-writer (span-writer) => ()

   :parameter span-writer: An instance of :class:`<span-writer>`.

   See also:

   * :class:`<span-writer>`
   * :func:`register-span-writer`
   * :func:`registered-span-writers`

Writer Implementation
---------------------

To add a new storage, subclass :class:`<span-writer>` and
implement the :gf:`span-writer-add-span` method. Then, call
:func:`register-span-writer` with an instance of your span
writer and all subsequent spans completed will be written to it.

.. generic-function:: span-writer-add-span

   :signature: span-writer-add-span (span span-writer) => ()

   :parameter span: An instance of :class:`<span>`.
   :parameter span-writer: An instance of :class:`<span-writer>`.

   :description:

      This method is specialized for each subclass of
      :class:`<span-writer>`. It is called whenever a span
      needs to be processed by a span writer.

Miscellaneous
-------------

.. function:: get-unique-id

   :signature: get-unique-id () => (id)

   :value id: An instance of ``<unique-id>``.

