const std = @import("std");

pub fn build(b: *std.Build) !void {
    _ = b.addModule("tigerbeetle_io", .{
        .root_source_file = b.path("io.zig"),
    });
}
