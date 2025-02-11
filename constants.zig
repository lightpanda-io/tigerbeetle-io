/// The minimum size of an aligned kernel page and an Advanced Format disk sector:
/// This is necessary for direct I/O without the kernel having to fix unaligned pages with a copy.
/// The new Advanced Format sector size is backwards compatible with the old 512 byte sector size.
/// This should therefore never be less than 4 KiB to be future-proof when server disks are swapped.
pub const sector_size = 4096;

/// Whether to perform direct I/O to the underlying disk device:
/// This enables several performance optimizations:
/// * A memory copy to the kernel's page cache can be eliminated for reduced CPU utilization.
/// * I/O can be issued immediately to the disk device without buffering delay for improved latency.
/// This also enables several safety features:
/// * Disk data can be scrubbed to repair latent sector errors and checksum errors proactively.
/// * Fsync failures can be recovered from correctly.
/// WARNING: Disabling direct I/O is unsafe; the page cache cannot be trusted after an fsync error,
/// even after an application panic, since the kernel will mark dirty pages as clean, even
/// when they were never written to disk.
pub const direct_io = true;
pub const direct_io_required = true;

/// The number of milliseconds between each replica tick, the basic unit of time in TigerBeetle.
/// Used to regulate heartbeats, retries and timeouts, all specified as multiples of a tick.
pub const tick_ms = 10;

/// TigerBeetle uses asserts proactively, unless they severely degrade performance. For production,
/// 5% slow down might be deemed critical, tests tolerate slowdowns up to 5x. Tests should be
/// reasonably fast to make deterministic simulation effective. `constants.verify` disambiguate the
/// two cases.
///
/// In the control plane (eg, vsr proper) assert unconditionally. Due to batching, control plane
/// overhead is negligible. It is acceptable to spend O(N) time to verify O(1) computation.
///
/// In the data plane (eg, lsm tree), finer grained judgement is required. Do an unconditional O(1)
/// assert before an O(N) loop (e.g, a bounds check). Inside the loop, it might or might not be
/// feasible to add an extra assert per iteration. In the latter case, guard the assert with `if
/// (constants.verify)`, but prefer an unconditional assert unless benchmarks prove it to be costly.
///
/// In the data plane, never use O(N) asserts for O(1) computations --- due to do randomized testing
/// the overall coverage is proportional to the number of tests run. Slow thorough assertions
/// decrease the overall test coverage.
///
/// Specific data structures might use a comptime parameter, to enable extra costly verification
/// only during unit tests of the data structure.
pub const verify = false;
