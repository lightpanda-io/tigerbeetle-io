const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    _ = b.addModule("tigerbeetle_io", .{
        .root_source_file = b.path("io.zig"),
        .target = target,
        .optimize = optimize,
    });
}
