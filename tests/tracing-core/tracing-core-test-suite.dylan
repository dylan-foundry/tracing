module: tracing-core-test-suite
synopsis: Test suite for the tracing-core library.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define suite tracing-core-test-suite ()
  test test-span-annotations;
  test test-span-data;
  test test-span-stopped;
  test test-span-accumulated-time;
  test test-always-sample;
  test test-never-sample;
  test test-if-tracing-sample;
  test test-span-writer-registration;
  test test-span-writer-storage;
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

define test test-always-sample ()
  assert-true($always-sample());
end test;

define test test-never-sample ()
  assert-false($never-sample());
end test;

define test test-if-tracing-sample ()
  enable-tracing();
  assert-true(tracing-enabled?());
  assert-true($if-tracing-sample());

  disable-tracing();
  assert-false(tracing-enabled?());
  assert-false($if-tracing-sample());
end test;

define test test-span-writer-registration ()
  assert-true(empty?(registered-span-writers()));

  let span-writer = make(<memory-span-writer>);
  assert-no-errors(register-span-writer(span-writer));
  assert-equal(1, registered-span-writers().size);

  assert-no-errors(unregister-span-writer(span-writer));
  assert-equal(0, registered-span-writers().size);
end test;

define test test-span-writer-storage ()
  let span-writer = make(<memory-span-writer>);
  assert-true(empty?(span-writer.memory-span-storage));
  register-span-writer(span-writer);

  let span = make(<span>, trace-id: get-unique-id(), description: "Test");
  span-stop(span);
  assert-equal(1, span-writer.memory-span-storage.size);
  assert-equal("Test", span-writer.memory-span-storage[0].span-description);
end test;
