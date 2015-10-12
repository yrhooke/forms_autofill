
for /f %%i in ('cd') do set origin=%%i

for /f %%i in ('where pdftk') do set pdftk1=%%i

cd %~dp0

mklink %pdftk1% bin/pdftk

cd %origin%

bundle install