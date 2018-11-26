const std = @import("std");

const Allocator = std.mem.Allocator;

/// An "IdioticAllocator." An idiotic allocator that does not free, ignores
/// alignment and simply returns an offset into a static buffer. Not useful
/// for anything but a learning tool.
pub fn IdioticAllocator(comptime bufferSize: usize) type {
  return struct {
    const Self = @This();
    buffer: [bufferSize]u8,
    index: usize,
    pub allocator: Allocator,

    fn allocFn(allocator: *Allocator, n: usize, alignment: u29) ![]u8 {
      const self = @fieldParentPtr(Self, "allocator", allocator);
      if (n + self.index > self.buffer.len) {
        return Allocator.Error.OutOfMemory;
      }

      var ret = self.buffer[self.index..n+self.index];
      self.index += n;
      return ret;
    }

    fn reallocFn(self: *Allocator, old_mem: []u8, new_size: usize, alignment: u29) ![]u8 {
      return self.allocFn(self, new_size, alignment);
    }

    fn freeFn(self: *Allocator, old_mem: []u8) void {}

    pub fn init() Self {
      return Self {
        .allocator = Allocator {
          .allocFn = allocFn,
          .reallocFn = reallocFn,
          .freeFn = freeFn
        },
        .buffer = []u8{0} ** bufferSize,
        .index = 0
      };
    }
  };
}
