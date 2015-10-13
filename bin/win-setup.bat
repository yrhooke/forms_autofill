
for /f %%i in ('cd') do set origin=%%i

cd %~dp0

where pdftk > db/pdftk

cd %origin%

bundle install