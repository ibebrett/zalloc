const std = @import("std");

const Allocator = std.mem.Allocator;

const bufferSize = 2048;
var buffer = []u8{0} ** bufferSize;

/// A "IdioticAllocator." An idiotic allocator that does not free, ignores
/// alignment and simply returns an offset into a static buffer. Not useful
/// for anything but a learning tool.
pub const IdioticAllocator = struct {
  index: usize,
  pub allocator: Allocator,

  fn allocFn(allocator: *Allocator, n: usize, alignment: u29) ![]u8 {
    const self = @fieldParentPtr(IdioticAllocator, "allocator", allocator);

    if (n > bufferSize) {
      return Allocator.Error.OutOfMemory;
    }

    var ret = buffer[self.index..n+self.index];
    self.index += n;
    return ret;
  }

  fn reallocFn(self: *Allocator, old_mem: []u8, new_size: usize, alignment: u29) ![]u8 {
    return self.allocFn(self, new_size, alignment);
  }

  fn freeFn(self: *Allocator, old_mem: []u8) void {}

  pub fn init() IdioticAllocator {
    return IdioticAllocator {
      .allocator = Allocator {
        .allocFn = allocFn,
        .reallocFn = reallocFn,
        .freeFn = freeFn
      },
      .index = 0
    };
  }
};

pub var idiotic_allocator = IdioticAllocator.init().allocator;
