library vec;

use ::context::registers::heap_ptr;

struct RawVec<T> {
    ptr: u64,
    cap: u64,
}

impl<T> RawVec<T> {
    /// Create a new `RawVec` with zero capacity.
    fn new() -> Self {
        RawVec {
            ptr: heap_ptr(),
            cap: 0,
        }
    }

    /// Creates a `RawVec` (on the heap) with exactly the capacity for a
    /// `[T; capacity]`. This is equivalent to calling `RawVec::new` when
    /// `capacity` is `0`.
    fn with_capacity(capacity: u64) -> Self {
        let v = RawVec {
            ptr: heap_ptr(),
            cap: capacity,
        };

        asm(size: capacity * size_of::<T>()) {
            aloc size;
        };

        return v;
    }

    /// Gets the pointer of the allocation.
    fn ptr(self) -> u64 {
        self.ptr
    }

    /// Gets the capacity of the allocation.
    fn capacity(self) -> u64 {
        self.cap
    }

    fn grow(self) {
        let new_cap = if self.cap == 0 {
            1
        } else {
            2 * self.cap
        };

        // Allocate for `new_cap` elements.
        let new_ptr = (heap_ptr());
        asm(size: new_cap * size_of::<T>()) {
            aloc size;
        };

        // Copy old contents into newly-allocated memory.
        // TODO actually do this

        self.ptr = new_ptr;
        self.cap = new_cap;
    }
}

/// A contiguous growable array type, written as `Vec<T>`, short for 'vector'.
pub struct Vec<T> {
    buf: RawVec,
    len: u64,
}

impl<T> Vec<T> {
    /// Constructs a new, empty `Vec<T>`.
    ///
    /// The vector will not allocate until elements are pushed onto it.
    pub fn new() -> Self {
        Vec {
            buf: ~RawVec::new(),
            len: 0,
        }
    }

    /// Constructs a new, empty `Vec<T>` with the specified capacity.
    ///
    /// The vector will be able to hold exactly `capacity` elements without
    /// reallocating. If `capacity` is 0, the vector will not allocate.
    ///
    /// It is important to note that although the returned vector has the
    /// *capacity* specified, the vector will have a zero *length*.
    pub fn with_capacity(capacity: u64) -> Self {
        Vec {
            buf: ~RawVec::with_capacity(capacity),
            len: 0,
        }
    }

    /// Appends an element to the back of a collection.
    pub fn push(self, value: T) {
        // If there is insufficient capacity, grow the buffer.
        if self.len == self.buf.capacity() {
            self.buf.grow();
        };
        // Get a pointer to the end of the buffer, where the new element will
        // be inserted.
        let end = self.buf.ptr() + self.len * size_of::<T>();

        // Loop over each word and insert it.
        // TODO actually do this
        asm(ptr: end) {
        };

        // Increment length.
        self.len = self.len + 1;
    }
}
