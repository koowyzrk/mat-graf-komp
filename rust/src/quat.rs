use std::{
    arch::x86_64::{__m128, _mm_add_ps, _mm_mul_ps, _mm_set_ps, _mm_set1_ps, _mm_sub_ps},
    fmt::Display,
    ops::{Add, Div, Mul, Sub},
};

use bytemuck::{Pod, Zeroable};
use zerocopy::{FromBytes, Immutable, IntoBytes, KnownLayout};

use crate::vector::Vec3;

#[repr(C)]
union UnionCast {
    a: [f32; 4],
    v: Quat,
}

#[derive(Clone, Copy, Pod, Zeroable, FromBytes, Immutable, IntoBytes, KnownLayout)]
#[repr(transparent)]
pub struct Quat(pub(crate) __m128);

impl Quat {
    const ZERO: Self = Self::from_xyzw(0., 0., 0., 0.);

    #[inline(always)]
    #[must_use]
    pub const fn from_xyzw(x: f32, y: f32, z: f32, w: f32) -> Self {
        unsafe { UnionCast { a: [x, y, z, w] }.v }
    }

    #[inline(always)]
    pub fn to_xyzw(self) -> (f32, f32, f32, f32) {
        self.into()
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
        // let times_two_and_add = |(x, y, z, w)| x * x + y * y + z * z + w * w;
        // times_two_and_add(self.into())
        let xd = unsafe {
            UnionCast {
                v: Self(_mm_mul_ps(self.0, self.0)),
            }
            .a
        };
        xd[0] + xd[1] + xd[2] + xd[3]
    }

    pub fn inverse(self) -> Self {
        self.conjugate().scale(1. / self.snorm())
    }

    pub fn magnitude(self) -> f32 {
        self.snorm().sqrt()
    }

    pub fn normalized(self) -> Self {
        let mag = self.magnitude();
        self.scale(1.0 / mag)
    }

    pub fn from_axis_angle(axis: [f32; 3], angle_deg: f32) -> Self {
        let (ax, ay, az) = (axis[0], axis[1], axis[2]);
        let len = (ax * ax + ay * ay + az * az).sqrt();
        let (ax, ay, az) = (ax / len, ay / len, az / len);

        let theta = angle_deg.to_radians();
        let s = (theta * 0.5).sin();
        let w = (theta * 0.5).cos();

        Self::from_xyzw(ax * s, ay * s, az * s, w)
    }

    pub fn rotate_vector(self, v: Vec3) -> [f32; 3] {
        let qp = self * v;
        let (x, y, z, _) = qp.into();
        [x, y, z]
    }

    pub fn negate(self) -> Self {
        let (x, y, z, w): (f32, f32, f32, f32) = self.into();
        return unsafe {
            UnionCast {
                a: [-x, -y, -z, -w],
            }
            .v
        };
    }
}

impl Add for Quat {
    type Output = Self;

    fn add(self, rhs: Self) -> Self::Output {
        unsafe { Self(_mm_add_ps(self.0, rhs.0)) }
    }
}

impl Sub for Quat {
    type Output = Self;

    fn sub(self, rhs: Self) -> Self::Output {
        unsafe { Self(_mm_sub_ps(self.0, rhs.0)) }
    }
}

impl Mul for Quat {
    type Output = Self;

    #[inline(always)]
    fn mul(self, rhs: Self) -> Self {
        let (x1, y1, z1, w1) = self.into();
        let (x2, y2, z2, w2) = rhs.into();

        Quat::from_xyzw(
            w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2,
            w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2,
            w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2,
            w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2,
        )
    }
}

impl Div for Quat {
    type Output = Self;

    #[inline(always)]
    fn div(self, rhs: Self) -> Self {
        self.div(rhs)
    }
}

impl Mul<Vec3> for Quat {
    type Output = Self;

    #[inline(always)]
    fn mul(self, v: Vec3) -> Self {
        let q = self.normalized();
        let p = Quat::from_xyzw(v.x, v.y, v.z, 0.0);
        q.mul(p).mul(q.inverse())
    }
}

impl Mul<Quat> for Vec3 {
    type Output = Self;

    fn mul(self, rhs: Quat) -> Self {
        let p = Quat::from_xyzw(self.x, self.y, self.z, 0.0);

        let r = rhs.mul(p).mul(rhs.inverse());

        let (x, y, z, _) = r.into();
        Vec3 { x, y, z }
    }
}

impl From<[f32; 4]> for Quat {
    #[inline]
    fn from(a: [f32; 4]) -> Self {
        Self::from_xyzw(a[0], a[1], a[2], a[3])
    }
}

impl From<Quat> for (f32, f32, f32, f32) {
    #[inline(always)]
    fn from(value: Quat) -> (f32, f32, f32, f32) {
        unsafe {
            let arr: [f32; 4] = core::mem::transmute(value.0);
            (arr[0], arr[1], arr[2], arr[3])
        }
    }
}

impl Display for Quat {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let arr: [f32; 4] = unsafe { UnionCast { v: *self }.a };

        write!(f, "[{}, {}, {}, {}]", arr[0], arr[1], arr[2], arr[3])
    }
}
