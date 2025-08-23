#!/bin/sh
BUILD="../TestFloat-3e/build/Linux-x86_64-GCC"
OUTPUT="./vectors"
echo "Editing f16_mulAdd test vectors"
sed -i 's/ /_/g' $OUTPUT/f16_mulAdd_rne.tv
sed -i 's/ /_/g' $OUTPUT/f16_mulAdd_rz.tv
sed -i 's/ /_/g' $OUTPUT/f16_mulAdd_ru.tv
sed -i 's/ /_/g' $OUTPUT/f16_mulAdd_rd.tv
sed -i 's/ /_/g' $OUTPUT/f16_mulAdd_rnm.tv
echo "Editing f16_add test vectors"
sed -i 's/ /_/g' $OUTPUT/f16_add_rne.tv
sed -i 's/ /_/g' $OUTPUT/f16_add_rz.tv
sed -i 's/ /_/g' $OUTPUT/f16_add_ru.tv
sed -i 's/ /_/g' $OUTPUT/f16_add_rd.tv
sed -i 's/ /_/g' $OUTPUT/f16_add_rnm.tv
echo "Editing f16_sub test vectors"
sed -i 's/ /_/g' $OUTPUT/f16_sub_rne.tv
sed -i 's/ /_/g' $OUTPUT/f16_sub_rz.tv
sed -i 's/ /_/g' $OUTPUT/f16_sub_ru.tv
sed -i 's/ /_/g' $OUTPUT/f16_sub_rd.tv
sed -i 's/ /_/g' $OUTPUT/f16_sub_rnm.tv
echo "Editing conversion_f32_to_f64 vectors"
sed -i 's/ /_/g' $OUTPUT/f32_to_f64_rne.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_f64_rz.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_f64_ru.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_f64_rd.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_f64_rnm.tv
echo "Editing conversion_f64_to_f32 vectors"
sed -i 's/ /_/g' $OUTPUT/f64_to_f32_rne.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_f32_rz.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_f32_ru.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_f32_rd.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_f32_rnm.tv
echo "Editing conversion_f64_to_i64 vectors"
sed -i 's/ /_/g' $OUTPUT/f64_to_i64_rne.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i64_rz.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i64_ru.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i64_rd.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i64_rnm.tv
echo "Editing conversion_f64_to_i32 vectors"
sed -i 's/ /_/g' $OUTPUT/f64_to_i32_rne.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i32_rz.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i32_ru.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i32_rd.tv
sed -i 's/ /_/g' $OUTPUT/f64_to_i32_rnm.tv
echo "Editing conversion_f32_to_i64 vectors"
sed -i 's/ /_/g' $OUTPUT/f32_to_i64_rne.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i64_rz.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i64_ru.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i64_rd.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i64_rnm.tv
echo "Editing conversion_f32_to_i32 vectors"
sed -i 's/ /_/g' $OUTPUT/f32_to_i32_rne.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i32_rz.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i32_ru.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i32_rd.tv
sed -i 's/ /_/g' $OUTPUT/f32_to_i32_rnm.tv

