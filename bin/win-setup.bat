
for /f %%i in ('cd') do set origin=%%i

for /f "delims==" %%i in ('where pdftk') do set /p pdftk1= %%i

cd %~dp0

mklink %pdftk1% bin/pdftk

cd %origin%

bundle install