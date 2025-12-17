use std::{fmt, ops::Mul};

use crate::vector::Vec4;

#[derive(Clone, Debug)]
pub struct Mat {
    pub rows: usize,
    pub cols: usize,
    pub data: Vec<f32>,
}

impl Default for Mat {
    fn default() -> Self {
        Mat::identity(4)
    }
}

impl Mat {
    pub fn new(data: Vec<Vec<f32>>) -> Self {
        let rows = data.len();
        assert!(rows > 0, "Matrix must have at least one row");
        let cols = data[0].len();
        assert!(cols > 0, "Matrix must have at least one column");

        let flat = data.into_iter().flatten().collect::<Vec<_>>();
        Mat {
            rows,
            cols,
            data: flat,
        }
    }

    pub fn get(&self, row: usize, col: usize) -> f32 {
        self.data[row * self.cols + col]
    }

    pub fn set(&mut self, row: usize, col: usize, value: f32) {
        self.data[row * self.cols + col] = value;
    }

    pub fn add(&self, other: &Self) -> Self {
        assert_eq!(self.rows, other.rows, "Matrix addition: row mismatch");
        assert_eq!(self.cols, other.cols, "Matrix addition: column mismatch");

        let data = self
            .data
            .iter()
            .zip(other.data.iter())
            .map(|(a, b)| a + b)
            .collect();

        Mat {
            rows: self.rows,
            cols: self.cols,
            data,
        }
    }

    pub fn sub(&self, other: &Self) -> Self {
        assert_eq!(self.rows, other.rows, "Matrix subtraction: row mismatch");
        assert_eq!(self.cols, other.cols, "Matrix subtraction: column mismatch");

        let data = self
            .data
            .iter()
            .zip(other.data.iter())
            .map(|(a, b)| a - b)
            .collect();

        Mat {
            rows: self.rows,
            cols: self.cols,
            data,
        }
    }

    pub fn scalar(&self, k: f32) -> Self {
        let data = self.data.iter().map(|v| v * k).collect();
        Mat {
            rows: self.rows,
            cols: self.cols,
            data,
        }
    }

    pub fn transpose(&self) -> Self {
        let mut data = vec![0.0; self.rows * self.cols];
        for i in 0..self.rows {
            for j in 0..self.cols {
                data[j * self.rows + i] = self.get(i, j);
            }
        }
        Mat {
            rows: self.cols,
            cols: self.rows,
            data,
        }
    }

    pub fn multiply(&self, other: &Self) -> Self {
        assert_eq!(
            self.cols, other.rows,
            "Matrix multiplication: incompatible dimensions ({}x{} * {}x{})",
            self.rows, self.cols, other.rows, other.cols
        );

        let mut data = vec![0.0; self.rows * other.cols];

        for i in 0..self.rows {
            for j in 0..other.cols {
                let mut sum = 0.0;
                for k in 0..self.cols {
                    sum += self.get(i, k) * other.get(k, j);
                }
                data[i * other.cols + j] = sum;
            }
        }

        Mat {
            rows: self.rows,
            cols: other.cols,
            data,
        }
    }

    pub fn identity(size: usize) -> Self {
        let mut data = vec![0.0; size * size];
        for i in 0..size {
            data[i * size + i] = 1.0;
        }
        Mat {
            rows: size,
            cols: size,
            data,
        }
    }

    pub fn determinant(&self) -> f32 {
        assert_eq!(self.rows, self.cols, "Determinant: must be square");

        let n = self.rows;
        if n == 1 {
            return self.data[0];
        }
        if n == 2 {
            return self.get(0, 0) * self.get(1, 1) - self.get(0, 1) * self.get(1, 0);
        }

        let mut det = 0.0;
        for col in 0..n {
            let minor = self.minor(0, col);
            let sign = if col % 2 == 0 { 1.0 } else { -1.0 };
            det += sign * self.get(0, col) * minor.determinant();
        }
        det
    }

    fn minor(&self, exclude_row: usize, exclude_col: usize) -> Self {
        let mut data = Vec::new();
        for i in 0..self.rows {
            if i == exclude_row {
                continue;
            }
            let mut row = Vec::new();
            for j in 0..self.cols {
                if j == exclude_col {
                    continue;
                }
                row.push(self.get(i, j));
            }
            data.push(row);
        }
        Mat::new(data)
    }

    pub fn inverse(&self) -> Self {
        assert_eq!(self.rows, self.cols, "Inverse: must be square");

        let det = self.determinant();
        assert!(det != 0.0, "Matrix is not singular");

        let n = self.rows;
        let mut complement_data = vec![vec![0.0; n]; n];

        for i in 0..n {
            for j in 0..n {
                let minor = self.minor(i, j);
                let sign = if (i + j) % 2 == 0 { 1.0 } else { -1.0 };
                complement_data[i][j] = sign * minor.determinant();
            }
        }

        let complement = Mat::new(complement_data);
        let transponse = complement.transpose();

        transponse.scalar(1.0 / det)
    }

    // Transformations
    pub fn translate(a: f32, b: f32, c: f32) -> Self {
        let mut m = Mat::identity(4);
        m.set(0, 3, a);
        m.set(1, 3, b);
        m.set(2, 3, c);
        m
    }

    pub fn scale(a: f32, b: f32, c: f32) -> Self {
        let mut m = Mat::identity(4);
        m.set(0, 0, a);
        m.set(1, 1, b);
        m.set(2, 2, c);
        m
    }

    pub fn rotate_x(angle_rad: f32) -> Self {
        let mut m = Mat::identity(4);
        let c = angle_rad.cos();
        let s = angle_rad.sin();

        m.set(1, 1, c);
        m.set(1, 2, -s);
        m.set(2, 2, s);
        m.set(2, 2, c);
        m
    }

    pub fn rotate_y(angle_rad: f32) -> Self {
        let mut m = Mat::identity(4);
        let c = angle_rad.cos();
        let s = angle_rad.sin();

        m.set(0, 0, c);
        m.set(0, 2, s);
        m.set(2, 0, -s);
        m.set(2, 2, c);
        m
    }

    pub fn rotate_z(angle_rad: f32) -> Self {
        let mut m = Mat::identity(4);
        let c = angle_rad.cos();
        let s = angle_rad.sin();

        m.set(0, 0, c);
        m.set(0, 1, -s);
        m.set(1, 0, s);
        m.set(1, 1, c);
        m
    }

    pub fn perspective(fov_radians: f32, aspect: f32, near: f32, far: f32) -> Self {
        let f = 1.0 / (fov_radians / 2.0).tan();

        Mat::new(vec![
            vec![f / aspect, 0.0, 0.0, 0.0],
            vec![0.0, f, 0.0, 0.0],
            vec![
                0.0,
                0.0,
                (far + near) / (near - far),
                (2.0 * far * near) / (near - far),
            ],
            vec![0.0, 0.0, -1.0, 0.0],
        ])
    }
}

impl fmt::Display for Mat {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for i in 0..self.rows {
            for j in 0..self.cols {
                write!(f, "{:8.3} ", self.get(i, j))?;
            }
            writeln!(f)?;
        }
        Ok(())
    }
}

impl Mul<Mat> for &Mat {
    type Output = Mat;
    fn mul(self, rhs: Mat) -> Mat {
        self.multiply(&rhs)
    }
}

impl Mul<Mat> for Mat {
    type Output = Mat;
    fn mul(self, rhs: Mat) -> Mat {
        self.multiply(&rhs)
    }
}

impl Mul<&Mat> for &Mat {
    type Output = Mat;
    fn mul(self, rhs: &Mat) -> Mat {
        self.multiply(&rhs)
    }
}

impl Mul<&Mat> for Mat {
    type Output = Mat;
    fn mul(self, rhs: &Mat) -> Mat {
        self.multiply(&rhs)
    }
}

impl Mat {
    pub fn mul_vec4(&self, v: Vec4) -> Vec4 {
        assert_eq!(self.rows, 4, "Matrix must be 4x4 for Vec4 multiplication");
        assert_eq!(self.cols, 4, "Matrix must be 4x4 for Vec4 multiplication");

        let x = self.get(0, 0) * v.x
            + self.get(0, 1) * v.y
            + self.get(0, 2) * v.z
            + self.get(0, 3) * v.w;

        let y = self.get(1, 0) * v.x
            + self.get(1, 1) * v.y
            + self.get(1, 2) * v.z
            + self.get(1, 3) * v.w;

        let z = self.get(2, 0) * v.x
            + self.get(2, 1) * v.y
            + self.get(2, 2) * v.z
            + self.get(2, 3) * v.w;

        let w = self.get(3, 0) * v.x
            + self.get(3, 1) * v.y
            + self.get(3, 2) * v.z
            + self.get(3, 3) * v.w;

        Vec4::new(x, y, z, w)
    }
}

impl Mul<Vec4> for Mat {
    type Output = Vec4;

    fn mul(self, rhs: Vec4) -> Vec4 {
        self.mul_vec4(rhs)
    }
}

impl Mul<&Vec4> for &Mat {
    type Output = Vec4;

    fn mul(self, rhs: &Vec4) -> Vec4 {
        self.mul_vec4(*rhs)
    }
}

impl Mul<&Mat> for &Vec4 {
    type Output = Vec4;

    fn mul(self, rhs: &Mat) -> Vec4 {
        rhs.mul_vec4(*self)
    }
}
