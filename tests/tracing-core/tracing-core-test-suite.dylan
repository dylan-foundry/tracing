module: tracing-core-test-suite
synopsis: Test suite for the tracing-core library.
author: Bruce Mitchener, Jr.
copyright: See LICENSE file in this distribution.

define suite tracing-core-test-suite ()
  test test-span-annotations;
  test test-span-data;
  test test-span-stopped;
  test test-span-duration;
  test test-always-sample;
  test test-never-sample;
  test test-if-tracing-sample;
  test test-span-writer-registration;
  test test-span-writer-storage;
  test test-trace-interface;
  test test-trace-interface-never-sampling;
  test test-nested-traces;
  test test-trace-host;
  test test-with-tracing;
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

  assert-false(span.span-stopped?, "spans should start out running");

  assert-no-errors(span-stop(span));
  assert-true(span.span-stopped?);
end test;

define test test-span-duration ()
  let span = make(<span>, trace-id: get-unique-id(), description: "Test");

  assert-false(span.span-duration, "spans have no duration while running");

  assert-no-errors(span-stop(span));
  let duration = span.span-duration;
  assert-true((duration.duration-seconds > 0) | (duration.duration-microseconds > 0));
end test;

define test test-always-sample ()
  assert-true(always-sample());
end test;

define test test-never-sample ()
  assert-false(never-sample());
end test;

define test test-if-tracing-sample ()
  disable-tracing();
  assert-false(tracing-enabled?());
  assert-false(if-tracing-sample());

  enable-tracing();
  assert-true(tracing-enabled?());
  assert-true(if-tracing-sample());

  // Make sure we leave it enabled here for future tests
  // since the default sampler is ``if-tracing-sample``.
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

  // Don't interfere with subsequent tests.
  unregister-span-writer(span-writer);
end test;

define test test-trace-interface ()
  let span? :: false-or(<span>) = #f;
  assert-no-errors(span? := trace-push("Test"));
  assert-true(span?);
  if (span?)
    let span :: <span> = span?;
    assert-equal(1, trace-current-spans().size);
    assert-no-errors(trace-add-data("key", "value"));
    assert-equal(2, span.span-data.size);
    assert-no-errors(trace-annotate("test annotation"));
    assert-equal(1, span.span-annotations.size);
    assert-no-errors(trace-pop(span));
    assert-true(empty?(trace-current-spans()));
    assert-true(span-stopped?(span));
  end if;
end test;

define test test-trace-interface-never-sampling ()
  let span? :: false-or(<span>) = #f;
  assert-no-errors(span? := trace-push("Test", sampler: never-sample));
  assert-false(span?);
end test;

define test test-nested-traces ()
  let outer-span = trace-push("Outer");
  let inner-span = trace-push("Inner");

  let current-spans = trace-current-spans();
  assert-equal(2, current-spans.size);
  assert-equal("Outer", current-spans[1].span-description);
  assert-equal("Inner", current-spans[0].span-description);
  assert-equal(outer-span.span-id, inner-span.span-parent-id);
  assert-equal(outer-span.span-trace-id, inner-span.span-trace-id);
  assert-false(outer-span.span-id == inner-span.span-id);

  trace-pop(inner-span);
  trace-pop(outer-span);
end test;

define test test-trace-host ()
  assert-no-errors(trace-set-host("abc"));
  let span = make(<span>, trace-id: get-unique-id(), description: "Test");
  assert-equal("abc", span-host(span));
end test test-trace-host;


define test test-with-tracing ()
  with-tracing ("Outer")
    trace-annotate("Outer");
    with-tracing ("Inner")
      trace-annotate("Inner");

      let current-spans = trace-current-spans();
      assert-equal(2, current-spans.size);
      let outer-span = current-spans[1];
      let inner-span = current-spans[0];
      assert-equal(1, outer-span.span-annotations.size);
      assert-equal(1, inner-span.span-annotations.size);
      assert-equal("Outer", outer-span.span-annotations[0].annotation-description);
      assert-equal("Inner", inner-span.span-annotations[0].annotation-description);

    end with-tracing;
  end with-tracing;
end test;
