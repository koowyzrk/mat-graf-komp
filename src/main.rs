pub trait Vector {
    const ZERO: Self;
    fn cross(&self, v: Self) -> Self;
    fn dot(&self, v: Self) -> Self;
    fn dot_product(&self, v: Self) -> f32;
    fn add(&self, v: Self) -> Self;
    fn sub(&self, v: Self) -> Self;
    fn mul(&self, d: f32) -> Self;
    fn div(&self, d: f32) -> Self;
    fn length(&self) -> f32;
    fn normalize(&self) -> Self;
    fn angle(&self, v: Self) -> f32;
}

#[derive(Copy, Clone, Debug)]
pub struct Vector2D {
    x: f32,
    y: f32,
}

#[derive(Copy, Clone, Debug)]
pub struct Vector3D {
    x: f32,
    y: f32,
    z: f32,
}

impl Vector2D {
    pub fn new(x: f32, y: f32) -> Vector2D {
        Vector2D { x, y }
    }
}
impl Vector3D {
    pub fn new(x: f32, y: f32, z: f32) -> Vector3D {
        Vector3D { x, y, z }
    }
}

impl Vector for Vector3D {
    const ZERO: Vector3D = Vector3D {
        x: 0.,
        y: 0.,
        z: 0.,
    };

    fn cross(&self, v: Self) -> Self {
        Self {
            x: self.y * v.z - self.z * v.y,
            y: self.z * v.x - self.x * v.z,
            z: self.x * v.y - self.y * v.x,
        }
    }

    fn dot(&self, v: Self) -> Self {
        Self {
            x: self.x * v.x,
            y: self.y * v.y,
            z: self.y * v.y,
        }
    }

    fn dot_product(&self, v: Self) -> f32 {
        self.x * v.x + self.y * v.y + self.z * v.z
    }

    fn add(&self, v: Self) -> Self {
        Self {
            x: self.x + v.x,
            y: self.y + v.y,
            z: self.z + v.z,
        }
    }

    fn sub(&self, v: Self) -> Self {
        Self {
            x: self.x - v.x,
            y: self.y - v.y,
            z: self.z - v.z,
        }
    }

    fn mul(&self, d: f32) -> Self {
        Self {
            x: self.x * d,
            y: self.y * d,
            z: self.z * d,
        }
    }

    fn div(&self, d: f32) -> Self {
        Self {
            x: self.x / d,
            y: self.y / d,
            z: self.z / d,
        }
    }

    fn length(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2) + self.z.powi(2)).sqrt()
    }

    fn normalize(&self) -> Self {
        let length = self.length();

        if length != 0. {
            return self.div(length);
        }

        Self::ZERO
    }

    fn angle(&self, v: Self) -> f32 {
        (self.dot_product(v) / (self.length() * v.length())).acos()
    }
}

impl Vector for Vector2D {
    const ZERO: Vector2D = Vector2D { x: 0., y: 0. };

    fn cross(&self, v: Self) -> Self {
        Self {
            x: self.x * v.y - self.y * v.x,
            y: self.y * v.x - self.x * v.y,
        }
    }

    fn dot(&self, v: Self) -> Self {
        Self {
            x: self.x * v.x,
            y: self.y * v.y,
        }
    }

    fn dot_product(&self, v: Self) -> f32 {
        self.x * v.x + self.y * v.y
    }

    fn add(&self, v: Self) -> Self {
        Self {
            x: self.x + v.x,
            y: self.y + v.y,
        }
    }

    fn sub(&self, v: Self) -> Self {
        Self {
            x: self.x - v.x,
            y: self.y - v.y,
        }
    }

    fn mul(&self, d: f32) -> Self {
        Self {
            x: self.x * d,
            y: self.y * d,
        }
    }

    fn div(&self, d: f32) -> Self {
        Self {
            x: self.x / d,
            y: self.y / d,
        }
    }

    fn length(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }

    fn normalize(&self) -> Self {
        let length = self.length();

        if length != 0. {
            return self.div(length);
        }

        Self::ZERO
    }

    fn angle(&self, v: Self) -> f32 {
        (self.dot_product(v) / (self.length() * v.length())).acos()
    }
}

fn main() {
    let v1 = Vector3D::new(0., 3., 0.);
    let v2 = Vector3D::new(5., 5., 0.);

    println!("{:?}", v1.angle(v2).to_degrees());

    let v1 = Vector3D::new(4., 5., 1.);
    let v2 = Vector3D::new(4., 1., 3.);

    println!("{:?}", v1.cross(v2));
    println!("{:?}", v1.cross(v2).normalize());
}
