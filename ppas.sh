#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking Analisador_Lotofacil
OFS=$IFS
IFS="
"
/usr/bin/ld -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2    -L. -o Analisador_Lotofacil link.res
if [ $? != 0 ]; then DoExitLink Analisador_Lotofacil; fi
IFS=$OFS
echo Linking Analisador_Lotofacil
OFS=$IFS
IFS="
"
/usr/bin/objcopy --only-keep-debug Analisador_Lotofacil Analisador_Lotofacil.dbg
if [ $? != 0 ]; then DoExitLink Analisador_Lotofacil; fi
IFS=$OFS
echo Linking Analisador_Lotofacil
OFS=$IFS
IFS="
"
/usr/bin/objcopy --add-gnu-debuglink=Analisador_Lotofacil.dbg Analisador_Lotofacil
if [ $? != 0 ]; then DoExitLink Analisador_Lotofacil; fi
IFS=$OFS
echo Linking Analisador_Lotofacil
OFS=$IFS
IFS="
"
/usr/bin/strip --strip-unneeded Analisador_Lotofacil
if [ $? != 0 ]; then DoExitLink Analisador_Lotofacil; fi
IFS=$OFS
