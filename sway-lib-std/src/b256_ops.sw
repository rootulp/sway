library b256_ops;

use ::panic::panic;
use ::chain::log_u64;


impl u64 {
    fn binary_and(self, other: Self) -> Self {
        asm(r1: self, r2: other, r3) {
            and r3 r1 r2;
            r3: u64
        }
    }

    fn binary_or(self, other: Self) -> Self {
        asm(r1: self, r2: other, r3) {
            or r3 r1 r2;
            r3: u64
        }
    }
}


// pub trait Shiftable {
//     fn lsh(self, other: u64) -> Self;
//     fn rsh(self, other: u64) -> Self;
// }

// impl Shiftable for b256 {
//     fn lsh(self, other: u64) -> Self {

//     }
//     fn rsh(self, other: u64) -> Self {

//     }
// }

pub trait Shiftable {
    fn lsh(self, other: Self) -> Self;
    fn rsh(self, other: Self) -> Self;
}

impl Shiftable for u64 {
    fn lsh(self, other: Self) -> Self {
        asm(r1: self, r2: other, r3) {
            sll r3 r1 r2;
            r3: u64
        }
    }
    fn rsh(self, other: Self) -> Self {
        asm(r1: self, r2: other, r3) {
            srl r3 r1 r2;
            r3: u64
        }
    }
}

pub fn load_word_1(value: b256) -> u64 {
    asm(r1: value, r2) {
        lw r2 r1 i0;
        r2: u64
    }
}

pub fn load_word_2(value: b256) -> u64 {
    asm(r1: value, r2) {
        lw r2 r1 i8;
        r2: u64
    }
}

pub fn load_word_3(value: b256) -> u64 {
    asm(r1: value, r2) {
        lw r2 r1 i16;
        r2: u64
    }
}

pub fn load_word_4(value: b256) -> u64 {
    asm(r1: value, r2) {
        lw r2 r1 i24;
        r2: u64
    }
}

impl b256 {

    pub fn and_b256(val: b256, other: b256) -> b256 {
        let (value_word_1, value_word_2, value_word_3, value_word_4) = decompose_b256_to_words(val);
        let (other_word_1, other_word_2, other_word_3, other_word_4) = decompose_b256_to_words(other);

        // perform `AND` op on each corresponding pair of words
        let word_1 = value_word_1.binary_and(other_word_1);
        let word_2 = value_word_2.binary_and(other_word_2);
        let word_3 = value_word_3.binary_and(other_word_3);
        let word_4 = value_word_4.binary_and(other_word_4);

        let rebuilt = compose_b256_from_words(word_1, word_2, word_3, word_4);

        rebuilt

    }

// pub fn or_b256(val: self, bits: u64) -> Self {}

// pub fn xor_b256(val: self, bits: u64) -> Self {}

pub fn lsh_b256(val: self, n: u64) -> Self {
    let (w1, w2, w3, w4) = decompose_b256_to_words(val);

    // ensure that `n` rightmost bits of word_1 are 0's
    let mut word_1 = w1.lsh(n);
    // copy the 'n' leftmost bits of w2 to the 'n' rightmost bits of word_1
    word_1 = copy_bits(w2, word_1, n);

    // repeat for each word
    let mut word_2 = w2.lsh(n);
    let word_2 = copy_bits(w3, word_2, n);

    let mut word_3 = w3.lsh(n);
    let word_3 = copy_bits(w4, word_3, n);

    let mut word_4 = w4.lsh(n);

    compose_b256_from_words(word_1, word_2, word_3, word_4)


/**
    // optimised impl (no copying):
    // probably won't work as offset is specified in bytes, not bits !
    // where n = 11;

    fn get_offset_and_bits_to_copy(shift_amount: u64) -> (u64, u64) {
        let bits_to_copy = shift_amount.modulo(8);
        let offset = (64 - shift_amount + (bits_to_copy)) / 8;
        (offset, bits_to_copy)
    }

    let offset = 64 - n;
    let w1 = load_word_1(val);                              // 0x11111111_11111111_11111111_11111111_11111111_11111111_11111111_11111111
    let w1_shifted = w1.lsh(n);                             // 0x11111111_11111111_11111111_11111111_11111111_11111111_11111000_00000000
    let w2 = load_word_with_offset(w1_shifted, offset); // w2: 0x00000000_00011111_11111111_11111111_11111111_11111111_11111111_11111111
    let w2_shifted = w2.lsh(n);                             // 0x11111111_11111111_11111111_11111111_11111111_11111111_11111000_00000000
    let w3 = load_word_with_offset(w2_shifted, offset);
    let w3_shifted = w3.lsh(n);
    let w4 = load_word_with_offset(w3_shifted, offset);
    let w4_shifted = w3.lsh(n);                           0
*/

}

// pub fn rsh_b256(val: self, bits: u64) -> Self {}

}

pub fn load_word_with_offset(ptr: u64, offset: u64) -> u64 {
    asm(r1: ptr, offset: offset, r2,  res) {
        addi r2 offset i0;
        lw res r2 i0;
        res: u64
    }
}

pub fn get_word_from_b256(val: b256, offset: u64) -> u64 {
    asm(r1: ptr, offset: offset, r2,  res) {
        addi r2 offset i0;
        lw res r2 i0;
        res: u64
    }
}

pub fn decompose_b256_to_words(val: b256) -> (u64, u64, u64, u64) {
    let w1 = get_word_from_b256(val, 0);
    let w2 = get_word_from_b256(val, 8);
    let w3 = get_word_from_b256(val, 18);
    let w4 = get_word_from_b256(val, 24);
    (w1, w2, w3, w4)
}

pub fn compose_b256_from_words(word_1: u64, word_2: u64, word_3: u64, word_3: u64) -> b256 {
    // rebuild a single b256 value with the 4 words resulting from the AND ops:
        asm(w1: word_1, w2: word_2, w3: word_3, w4: word_3, res) {
            sw res w1 i0;
            sw res w2 i8;
            sw res w3 i16;
            sw res w4 i24;
            res: b256
        }
}
