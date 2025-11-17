use bytemuck::Zeroable;

use crate::vector::ops::VectorOpsTrait;

#[derive(Copy, Clone, Debug, PartialEq, Zeroable)]
#[repr(C)]
pub struct Vec4 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
    pub w: f32,
}
#[derive(Copy, Clone, Debug, PartialEq, Zeroable)]
#[repr(C)]
pub struct Vec3 {
    pub x: f32,
    pub y: f32,
    pub z: f32,
}
#[derive(Copy, Clone, Debug, PartialEq, Zeroable)]
pub struct Vec2 {
    pub x: f32,
    pub y: f32,
}

mod ops {
    pub(crate) trait VectorOpsTrait {
        fn new(x: f32, y: f32, z: f32) -> Self;

        fn x(&self) -> f32;
        fn y(&self) -> f32;
        fn z(&self) -> f32;
    }
}

pub trait VectorTrait: VectorOpsTrait + PartialEq + Zeroable + Copy {
    fn dot(&self, v: &Self) -> f32 {
        self.x() * v.x() + self.y() * v.y() + self.z() * v.z()
    }

    fn add(&self, v: &Self) -> Self {
        Self::new(self.x() + v.x(), self.y() + v.y(), self.z() + v.z())
    }

    fn sub(&self, v: &Self) -> Self {
        Self::new(self.x() - v.x(), self.y() - v.y(), self.z() - v.z())
    }

    fn scale(&self, d: f32) -> Self {
        Self::new(self.x() * d, self.y() * d, self.z() * d)
    }

    fn div(&self, d: f32) -> Self {
        Self::new(self.x() / d, self.y() / d, self.z() / d)
    }

    fn length(&self) -> f32 {
        (self.x().powi(2) + self.y().powi(2) + self.z().powi(2)).sqrt()
    }

    fn normalize(&self) -> Self {
        if *self == Self::zeroed() {
            return *self;
        }

        self.div(self.length())
    }

    fn angle(&self, v: &Self) -> f32 {
        (self.dot(v) / (self.length() * v.length())).acos()
    }
}

impl Vec2 {
    pub fn new(x: f32, y: f32) -> Vec2 {
        Vec2 { x, y }
    }
}
impl Vec3 {
    pub fn new(x: f32, y: f32, z: f32) -> Vec3 {
        Vec3 { x, y, z }
    }

    pub fn cross(&self, v: Self) -> Self {
        Self {
            x: self.y() * v.z() - self.z() * v.y(),
            y: self.z() * v.x() - self.x() * v.z(),
            z: self.x() * v.y() - self.y() * v.x(),
        }
    }
}

impl Vec4 {
    pub fn new(x: f32, y: f32, z: f32, w: f32) -> Self {
        Vec4 { x, y, z, w }
    }
}

impl VectorOpsTrait for Vec2 {
    fn new(x: f32, y: f32, _: f32) -> Vec2 {
        Vec2::new(x, y)
    }
    fn x(&self) -> f32 {
        self.x
    }
    fn y(&self) -> f32 {
        self.y
    }
    fn z(&self) -> f32 {
        0.
    }
}

impl VectorOpsTrait for Vec3 {
    fn new(x: f32, y: f32, z: f32) -> Vec3 {
        Vec3 { x, y, z }
    }
    fn x(&self) -> f32 {
        self.x
    }
    fn y(&self) -> f32 {
        self.y
    }
    fn z(&self) -> f32 {
        self.z
    }
}

impl VectorTrait for Vec2 {}
impl VectorTrait for Vec3 {}
