library b256_ops;

use ::panic::panic;
use ::chain::log_u64;

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

pub fn and(value: u64, other: u64) -> u64 {
    asm(r1: value, r2: other, r3) {
        and r3 r1 r2;
        r3: u64
    }
}

impl b256 {

    pub fn and_b256(val: b256, other: b256) -> b256 {
        // split value into 4 words
        let value_word_1 = load_word_1(val);
        let value_word_2 = load_word_2(val);
        let value_word_3 = load_word_3(val);
        let value_word_4 = load_word_4(val);

        // split other into 4 words
        let other_word_1 = load_word_1(other);
        let other_word_2 = load_word_2(other);
        let other_word_3 = load_word_3(other);
        let other_word_4 = load_word_4(other);

        // perform `AND` op on each corresponding pair of words
        let word_1 = and(value_word_1, other_word_1);
        let word_2 = and(value_word_2, other_word_2);
        let word_3 = and(value_word_3, other_word_3);
        let word_4 = and(value_word_4, other_word_4);

        // rebuild a single b256 value with the 4 words resulting from the AND ops:
        asm(w1: word_1, w2: word_2, w3: word_3, w4: word_4, res) {
            sw res w1 i0;
            sw res w2 i8;
            sw res w3 i16;
            sw res w4 i24;
            res: b256
        }

    }

// pub fn or_b256(val: self, bits: u64) -> Self {}

// pub fn xor_b256(val: self, bits: u64) -> Self {}

// pub fn lsh_b256(val: self, bits: u64) -> Self {}

// pub fn rsh_b256(val: self, bits: u64) -> Self {}

}
