module: tracing-core-test-suite
synopsis: Test suite for the tracing-core library.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define suite tracing-core-test-suite ()
  test test-span-annotations;
  test test-span-data;
  test test-span-stopped;
  test test-span-accumulated-time;
end suite;

define test test-span-annotations ()
  let span = make(<span>, trace-id: get-unique-id(), description: "Test");

  assert-false(span.span-annotations, "annotations are lazily created");

  assert-no-errors(span-annotate(span, "Test annotation."));
  assert-equal(1, span.span-annotations.size);
  assert-equal("Test annotation.", annotation-description(span.span-annotations[0]));

  assert-no-errors(span-annotate(span, "Second test"));
  assert-equal(2, span.span-annotations.size);
  assert-equal("Second test", annotation-description(span.span-annotations[1]));
end test;

define test test-span-data ()
  let span = make(<span>, trace-id: get-unique-id(), description: "Test");

  assert-false(span.span-data, "data vector is lazily allocated");

  assert-no-errors(span-add-data(span, "key1", "value1"));
  assert-equal(2, span.span-data.size);
  assert-equal("key1", span.span-data[0]);
  assert-equal("value1", span.span-data[1]);

  assert-no-errors(span-add-data(span, "key2", "value2"));
  assert-equal(4, span.span-data.size);
  assert-equal("key2", span.span-data[2]);
  assert-equal("value2", span.span-data[3]);
end test;

define test test-span-stopped ()
  let span = make(<span>, trace-id: get-unique-id(), description: "Test");

  assert-false(span.span-stopped?, "spans should start out running")

  // TODO: More testing once setting timestamps is implemented.
end test;

define test test-span-accumulated-time ()
  let span = make(<span>, trace-id: get-unique-id(), description: "Test");

   assert-false(span.span-accumulated-time, "spans have no accumulated time while running");

  // TODO: More testing once setting timestamps is implemented.
end test;