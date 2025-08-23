#!/bin/sh
BUILD="../TestFloat-3ed/build/Linux-x86_64-GCC"
OUTPUT="./vectors"
echo "Creating f16_mulAdd vectors"
$BUILD/testfloat_gen -rnear_even f16_mulAdd > $OUTPUT/f16_mulAdd_rne.tv
$BUILD/testfloat_gen -rminMag f16_mulAdd > $OUTPUT/f16_mulAdd_rz.tv
$BUILD/testfloat_gen -rmax f16_mulAdd > $OUTPUT/f16_mulAdd_ru.tv
$BUILD/testfloat_gen -rmin f16_mulAdd > $OUTPUT/f16_mulAdd_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f16_mulAdd > $OUTPUT/f16_mulAdd_rnm.tv
echo "Creating f16_add vectors"
$BUILD/testfloat_gen -rnear_even f16_add > $OUTPUT/f16_add_rne.tv
$BUILD/testfloat_gen -rminMag f16_add > $OUTPUT/f16_add_rz.tv
$BUILD/testfloat_gen -rmax f16_add > $OUTPUT/f16_add_ru.tv
$BUILD/testfloat_gen -rmin f16_add > $OUTPUT/f16_add_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f16_add > $OUTPUT/f16_add_rnm.tv
echo "Creating f16_subtract vectors"
$BUILD/testfloat_gen -rnear_even f16_sub > $OUTPUT/f16_sub_rne.tv
$BUILD/testfloat_gen -rminMag f16_sub > $OUTPUT/f16_sub_rz.tv
$BUILD/testfloat_gen -rmax f16_sub > $OUTPUT/f16_sub_ru.tv
$BUILD/testfloat_gen -rmin f16_sub > $OUTPUT/f16_sub_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f16_sub > $OUTPUT/f16_sub_rnm.tv

echo "Creating conversion_f32_to_f64 vectors"
$BUILD/testfloat_gen -rnear_even f32_to_f64 > $OUTPUT/f32_to_f64_rne.tv
$BUILD/testfloat_gen -rminMag f32_to_f64 > $OUTPUT/f32_to_f64_rz.tv
$BUILD/testfloat_gen -rmax f32_to_f64 > $OUTPUT/f32_to_f64_ru.tv
$BUILD/testfloat_gen -rmin f32_to_f64 > $OUTPUT/f32_to_f64_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f32_to_f64 > $OUTPUT/f32_to_f64_rnm.tv
echo "Creating conversion_f64_to_f32 vectors"
$BUILD/testfloat_gen -rnear_even f64_to_f32 > $OUTPUT/f64_to_f32_rne.tv
$BUILD/testfloat_gen -rminMag f64_to_f32 > $OUTPUT/f64_to_f32_rz.tv
$BUILD/testfloat_gen -rmax f64_to_f32 > $OUTPUT/f64_to_f32_ru.tv
$BUILD/testfloat_gen -rmin f64_to_f32 > $OUTPUT/f64_to_f32_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f64_to_f32 > $OUTPUT/f64_to_f32_rnm.tv

echo "Creating conversion_f64_to_i64 vectors"
$BUILD/testfloat_gen -rnear_even f64_to_i64 > $OUTPUT/f64_to_i64_rne.tv
$BUILD/testfloat_gen -rminMag f64_to_i64 > $OUTPUT/f64_to_i64_rz.tv
$BUILD/testfloat_gen -rmax f64_to_i64 > $OUTPUT/f64_to_i64_ru.tv
$BUILD/testfloat_gen -rmin f64_to_i64 > $OUTPUT/f64_to_i64_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f64_to_i64 > $OUTPUT/f64_to_i64_rnm.tv
echo "Creating conversion_f64_to_i32 vectors"
$BUILD/testfloat_gen -rnear_even f64_to_i32 > $OUTPUT/f64_to_i32_rne.tv
$BUILD/testfloat_gen -rminMag f64_to_i32 > $OUTPUT/f64_to_i32_rz.tv
$BUILD/testfloat_gen -rmax f64_to_i32 > $OUTPUT/f64_to_i32_ru.tv
$BUILD/testfloat_gen -rmin f64_to_i32 > $OUTPUT/f64_to_i32_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f64_to_i32 > $OUTPUT/f64_to_i32_rnm.tv
echo "Creating conversion_f32_to_i64 vectors"
$BUILD/testfloat_gen -rnear_even f32_to_i64 > $OUTPUT/f32_to_i64_rne.tv
$BUILD/testfloat_gen -rminMag f32_to_i64 > $OUTPUT/f32_to_i64_rz.tv
$BUILD/testfloat_gen -rmax f32_to_i64 > $OUTPUT/f32_to_i64_ru.tv
$BUILD/testfloat_gen -rmin f32_to_i64 > $OUTPUT/f32_to_i64_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f32_to_i64 > $OUTPUT/f32_to_i64_rnm.tv
echo "Creating conversion_f32_to_i32 vectors"
$BUILD/testfloat_gen -rnear_even f32_to_i32 > $OUTPUT/f32_to_i32_rne.tv
$BUILD/testfloat_gen -rminMag f32_to_i32 > $OUTPUT/f32_to_i32_rz.tv
$BUILD/testfloat_gen -rmax f32_to_i32 > $OUTPUT/f32_to_i32_ru.tv
$BUILD/testfloat_gen -rmin f32_to_i32 > $OUTPUT/f32_to_i32_rd.tv
$BUILD/testfloat_gen -rnear_maxMag f32_to_i32 > $OUTPUT/f32_to_i32_rnm.tv



