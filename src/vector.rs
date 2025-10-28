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
