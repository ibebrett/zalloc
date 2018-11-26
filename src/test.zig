const zalloc = @import("zalloc/index.zig");

const std = @import("std");
const debug = std.debug;
const Allocator = std.mem.Allocator;

test "test idiotic alloc low value" {
  var ia = zalloc.IdioticAllocator(200).init();
  var slice = try ia.allocator.alloc(u8, 100);

  debug.assert(slice.len == 100);
}

test "test alloc too big" {
  var ia = zalloc.IdioticAllocator(200).init();
  if (ia.allocator.alloc(u8, 201)) |slice| {
    @panic("Should not be able to reserve an array of 10000");
  } else |err| {
    debug.assert(err == Allocator.Error.OutOfMemory);
  }
}
