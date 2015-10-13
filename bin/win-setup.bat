
for /f %%i in ('cd') do set origin=%%i

for /f "delims==" %%i in ('where pdftk') do set pdftk1= %%i

cd %~dp0

mklink "%pdftk1%" pdftk

cd %origin%

bundle install