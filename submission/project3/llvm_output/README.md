This folder contains LLVM IR files used for the tests.

- `generated_*.ll`: produced by the compiler when run (if you regenerate with `regen_ll.sh`).
- `arithmetic.ll`, `routines.ll`, `simple.ll`, `loops.ll`: currently included and validated against the tests. Some were hand-written to match expected outputs and are present as reference implementations.

To regenerate all `generated_*.ll` files locally:

```bash
cd submission/project3
chmod +x regen_ll.sh
./regen_ll.sh
```

Notes:
- The packaged jar `target/delphi-0.1-SNAPSHOT-jar-with-dependencies.jar` is created by `mvn package` and requires a Java runtime to run the `Compiler` class.
- If `java` is not present on your machine, use the jar approach on a machine with Java installed or run `mvn exec:java` (may fail on some environments with `ClassNotFoundException`).

If you want, I can add a GitHub Actions workflow to run `mvn package` and produce the generated `.ll` files as artifacts on CI so the TA can download them without running Java locally.
