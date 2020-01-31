nasm -felf64 cpuid.asm && \
$1 \
-DNDEBUG -O3 \
-ffunction-sections -fdata-sections -flto \
-finline-functions \
cpuid.o \
-o main