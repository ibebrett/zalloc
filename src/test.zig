const zalloc = @import("zalloc/index.zig");

const std = @import("std");
const debug = std.debug;
const Allocator = std.mem.Allocator;


test "test idiotic alloc low value" {
  var allocator: Allocator = zalloc.idiotic_allocator;
  var slice = try allocator.alloc(*i32, 100);

  debug.assert(slice.len == 100);
}

test "test alloc too big" {
  var allocator: Allocator = zalloc.idiotic_allocator;
  if (zalloc.idiotic_allocator.alloc(*i32, 10000)) |slice| {
    @panic("Should not be able to reserve an array of 10000");
  } else |err| {
    debug.assert(err == Allocator.Error.OutOfMemory);
  }
}
