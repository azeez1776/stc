use crate::Marks;
use once_cell::sync::Lazy;
use std::sync::Arc;
use swc_common::Globals;

pub(crate) static GLOBALS: Lazy<Arc<Globals>> = Lazy::new(Default::default);

pub(crate) static MARKS: Lazy<Marks> = Lazy::new(|| Marks::new(&*GLOBALS));