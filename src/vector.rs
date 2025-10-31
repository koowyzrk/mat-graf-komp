#[derive(Copy, Clone, Debug)]
pub struct Vector<const N: usize> {
    pub data: [f32; N],
}

impl<const N: usize> Vector<N> {
    pub const ZERO: Vector<N> = Vector { data: [0.0; N] };

    pub fn new(data: [f32; N]) -> Self {
        Vector { data }
    }

    pub fn length(&self) -> f32 {
        self.data.iter().map(|x| x * x).sum::<f32>().sqrt()
    }

    pub fn normalize(&self) -> Self {
        let len = self.length();
        if len != 0.0 {
            self.div(len)
        } else {
            Self::ZERO
        }
    }

    pub fn add(&self, v: Self) -> Self {
        let mut add: [f32; N] = [0.0; N];
        for i in 0..N {
            add[i] = self.data[i] + v.data[i];
        }
        Vector { data: add }
    }

    pub fn sub(&self, v: Self) -> Self {
        let mut sub: [f32; N] = [0.0; N];
        for i in 0..N {
            sub[i] = self.data[i] - v.data[i];
        }
        Vector { data: sub }
    }

    pub fn mul(&self, d: f32) -> Self {
        let mut mul: [f32; N] = [0.0; N];
        for i in 0..N {
            mul[i] = self.data[i] * d;
        }
        Vector { data: mul }
    }

    pub fn div(&self, d: f32) -> Self {
        if d != 0.0 {
            let mut div: [f32; N] = [0.0; N];
            for i in 0..N {
                div[i] = self.data[i] / d;
            }
            Vector { data: div }
        } else {
            Self::ZERO
        }
    }

    pub fn dot(&self, v: Self) -> f32 {
        let mut sum: f32 = 0.0;
        for i in 0..N {
            sum += self.data[i] * v.data[i];
        }
        sum
    }

    pub fn angle(&self, v: Self) -> Option<f32> {
        let length = self.length() * v.length();
        if length != 0.0 {
            Some((self.dot(v) / (self.length() * v.length())).acos())
        } else {
            None
        }
    }
}

impl Vector<3> {
    pub fn cross(&self, v: Self) -> Self {
        Vector::new([
            self.data[1] * v.data[2] - self.data[2] * v.data[1],
            self.data[2] * v.data[0] - self.data[0] * v.data[2],
            self.data[0] * v.data[1] - self.data[1] * v.data[0],
        ])
    }
}

// use bytemuck::Zeroable;
//
// use crate::vec::ops::VectorOpsTrait;
//
// #[derive(Copy, Clone, Debug, PartialEq, Zeroable)]
// pub struct Vector3D {
//     pub x: f32,
//     pub y: f32,
//     pub z: f32,
// }
// #[derive(Copy, Clone, Debug, PartialEq, Zeroable)]
// pub struct Vector2D {
//     pub x: f32,
//     pub y: f32,
// }
//
// mod ops {
//     pub(crate) trait VectorOpsTrait {
//         fn new(x: f32, y: f32, z: f32) -> Self;
//
//         fn x(&self) -> f32;
//         fn y(&self) -> f32;
//         fn z(&self) -> f32;
//     }
// }
//
// pub trait VectorTrait: VectorOpsTrait + PartialEq + Zeroable + Copy {
//     fn dot(&self, v: &Self) -> f32 {
//         self.x() * v.x() + self.y() * v.y() + self.z() * v.z()
//     }
//
//     fn add(&self, v: &Self) -> Self {
//         Self::new(self.x() + v.x(), self.y() + v.y(), self.z() + v.z())
//     }
//
//     fn sub(&self, v: &Self) -> Self {
//         Self::new(self.x() - v.x(), self.y() - v.y(), self.z() - v.z())
//     }
//
//     fn scale(&self, d: f32) -> Self {
//         Self::new(self.x() * d, self.y() * d, self.z() * d)
//     }
//
//     fn div(&self, d: f32) -> Self {
//         Self::new(self.x() / d, self.y() / d, self.z() / d)
//     }
//
//     fn length(&self) -> f32 {
//         (self.x().powi(2) + self.y().powi(2) + self.z().powi(2)).sqrt()
//     }
//
//     fn normalize(&self) -> Self {
//         if *self == Self::zeroed() {
//             return *self;
//         }
//
//         self.div(self.length())
//     }
//
//     fn angle(&self, v: &Self) -> f32 {
//         (self.dot(v) / (self.length() * v.length())).acos()
//     }
// }
//
// impl Vector2D {
//     pub fn new(x: f32, y: f32) -> Vector2D {
//         Vector2D { x, y }
//     }
// }
// impl Vector3D {
//     pub fn new(x: f32, y: f32, z: f32) -> Vector3D {
//         Vector3D { x, y, z }
//     }
//
//     pub fn cross(&self, v: Self) -> Self {
//         Self {
//             x: self.y() * v.z() - self.z() * v.y(),
//             y: self.z() * v.x() - self.x() * v.z(),
//             z: self.x() * v.y() - self.y() * v.x(),
//         }
//     }
// }
//
// impl VectorOpsTrait for Vector2D {
//     fn new(x: f32, y: f32, _: f32) -> Vector2D {
//         Vector2D::new(x, y)
//     }
//     fn x(&self) -> f32 {
//         self.x
//     }
//     fn y(&self) -> f32 {
//         self.y
//     }
//     fn z(&self) -> f32 {
//         0.
//     }
// }
//
// impl VectorOpsTrait for Vector3D {
//     fn new(x: f32, y: f32, z: f32) -> Vector3D {
//         Vector3D { x, y, z }
//     }
//     fn x(&self) -> f32 {
//         self.x
//     }
//     fn y(&self) -> f32 {
//         self.y
//     }
//     fn z(&self) -> f32 {
//         self.z
//     }
// }
//
// impl VectorTrait for Vector2D {}
// impl VectorTrait for Vector3D {}
