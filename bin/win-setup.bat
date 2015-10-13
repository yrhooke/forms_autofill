@echo off


for /f %%i in ('cd') do set origin=%%i

cd %~dp0

mkdir ../tmp
where pdftk > ../db/pdftk
cd %origin%

bundle install