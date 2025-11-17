use std::arch::x86_64::{__m128, _mm_mul_ps, _mm_set_ps, _mm_set1_ps};

use bytemuck::{Pod, Zeroable};
use zerocopy::{FromBytes, Immutable, IntoBytes, KnownLayout};

#[repr(C)]
union UnionCast {
    a: [f32; 4],
    v: Quat,
}

#[derive(Clone, Copy, Pod, Zeroable, FromBytes, Immutable, IntoBytes, KnownLayout)]
#[repr(transparent)]
pub struct Quat(pub(crate) __m128);

impl Quat {
    const ZERO: Self = Self::from_array([0.0; 4]);

    #[inline(always)]
    #[must_use]
    pub const fn from_xyzw(x: f32, y: f32, z: f32, w: f32) -> Self {
        unsafe { UnionCast { a: [x, y, z, w] }.v }
    }

    #[inline]
    #[must_use]
    pub const fn from_array(a: [f32; 4]) -> Self {
        Self::from_xyzw(a[0], a[1], a[2], a[3])
    }
    #[inline(always)]
    pub fn to_xyzw(self) -> (f32, f32, f32, f32) {
        unsafe {
            let arr: [f32; 4] = core::mem::transmute(self.0);
            (arr[0], arr[1], arr[2], arr[3])
        }
    }
    #[inline(always)]
    pub fn mul(self, other: Self) -> Self {
        let (x1, y1, z1, w1) = self.to_xyzw();
        let (x2, y2, z2, w2) = other.to_xyzw();

        Quat::from_xyzw(
            w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2,
            w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2,
            w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2,
            w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2,
        )
    }

    #[inline(always)]
    pub fn conjugate(self) -> Self {
        unsafe {
            let mask = _mm_set_ps(1.0, -1.0, -1.0, -1.0);
            Self(_mm_mul_ps(self.0, mask))
        }
    }

    #[inline(always)]
    pub fn scale(self, s: f32) -> Self {
        unsafe {
            let scalar = _mm_set1_ps(s);
            Self(_mm_mul_ps(self.0, scalar))
        }
    }

    pub fn div(self, o: Self) -> Self {
        self.mul(o.inverse())
    }

    pub fn snorm(self) -> f32 {
        let times_two_and_add = |(x, y, z, w)| return x * x + y * y + z * z + w * w;
        times_two_and_add(self.to_xyzw())
    }

    pub fn inverse(self) -> Self {
        self.conjugate().scale(1. / self.snorm())
    }
}
